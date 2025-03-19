package test

import (
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/stretchr/testify/assert"
)

func TestTerraformVNET(t *testing.T) {
	// Construct the terraform options with default retryable errors
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../modules/vnet",
		
		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"vnet_name":           "test-vnet",
			"resource_group_name": "test-rg",
			"location":            "eastus",
			"address_space":       []string{"10.0.0.0/16"},
			"subnets": map[string]interface{}{
				"test-subnet": map[string]interface{}{
					"address_prefix": "10.0.1.0/24",
					"create_nsg":     true,
					"nsg_rules": []map[string]interface{}{
						{
							"name":                       "test-rule",
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
			},
			"resource_prefix": "opella",
		},
	})

	// At the end of the test, run `terraform destroy`
	defer terraform.Destroy(t, terraformOptions)

	// Run `terraform init` and `terraform apply`
	terraform.InitAndApply(t, terraformOptions)

	// Get the subnet IDs and verify they match what we expect
	subnetIDs := terraform.OutputMap(t, terraformOptions, "subnet_ids")
	assert.Contains(t, subnetIDs, "test-subnet")
	
	// Validate VNET outputs
	vnetID := terraform.Output(t, terraformOptions, "vnet_id")
	assert.NotEmpty(t, vnetID)
	
	// Validate NSG rules were created correctly
	nsgIDs := terraform.OutputMap(t, terraformOptions, "nsg_ids")
	assert.Contains(t, nsgIDs, "test-subnet")
}