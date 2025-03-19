package test

import (
	"testing"
	"strings"
	"os"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/stretchr/testify/assert"
)

func TestVnetModule(t *testing.T) {
	// Skip if we're not running in a proper test environment
	if os.Getenv("TERRATEST_SKIP") != "" {
		t.Skip("Skipping test as TERRATEST_SKIP is set")
	}

	// Generate a random name to avoid conflicts
	uniqueID := strings.ToLower(terraform.RandomString(8))
	vnetName := "vnet-test-" + uniqueID
	resourceGroupName := "rg-test-" + uniqueID
	location := "eastus"

	// Terraform configuration
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../modules/vnet",
		Vars: map[string]interface{}{
			"vnet_name":           vnetName,
			"resource_group_name": resourceGroupName,
			"location":            location,
			"address_space":       []string{"10.0.0.0/16"},
			"subnets": map[string]interface{}{
				"subnet1": map[string]interface{}{
					"address_prefix": "10.0.1.0/24",
					"create_nsg":     true,
					"nsg_rules": []map[string]interface{}{
						{
							"name":                       "allow-https",
							"priority":                   100,
							"direction":                  "Inbound",
							"access":                     "Allow",
							"protocol":                   "Tcp",
							"source_port_range":          "*",
							"destination_port_range":     "443",
							"source_address_prefix":      "*",
							"destination_address_prefix": "*",
						},
					},
				},
				"subnet2": map[string]interface{}{
					"address_prefix": "10.0.2.0/24",
					"create_nsg":     false,
				},
			},
		},
	})

	// Create resource group for testing
	azure.CreateResourceGroup(t, location, resourceGroupName)
	
	// At the end of the test, clean up any resources
	defer terraform.Destroy(t, terraformOptions)
	defer azure.DeleteResourceGroup(t, resourceGroupName)
	
	// Deploy the module
	terraform.InitAndApply(t, terraformOptions)

	// Validate the outputs
	vnetID := terraform.Output(t, terraformOptions, "vnet_id")
	assert.Contains(t, vnetID, vnetName)
	
	subnetIDs := terraform.OutputMap(t, terraformOptions, "subnet_ids")
	assert.Equal(t, 2, len(subnetIDs))
	assert.Contains(t, subnetIDs, "subnet1")
	assert.Contains(t, subnetIDs, "subnet2")
	
	// Validate the subnet CIDR ranges
	subnetCIDRs := terraform.OutputMap(t, terraformOptions, "subnet_address_prefixes")
	assert.Equal(t, "10.0.1.0/24", subnetCIDRs["subnet1"])
	assert.Equal(t, "10.0.2.0/24", subnetCIDRs["subnet2"])
	
	// Validate NSG creation
	nsgIDs := terraform.OutputMap(t, terraformOptions, "nsg_ids")
	assert.Equal(t, 1, len(nsgIDs))
	assert.Contains(t, nsgIDs, "subnet1")
}