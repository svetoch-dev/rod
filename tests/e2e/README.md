# End-to-End (E2E) Infrastructure Tests

This repository contains a suite of scripts designed to perform end-to-end testing of the infrastructure template. These tests validate that the infrastructure can be provisioned and deprovisioned correctly based on a given configuration.

## Test Workflow

The E2E testing process follows these main steps:

1. **Configuration Preparation**  
   Generate or provide the necessary configuration files required for infrastructure deployment.

2. **Infrastructure Provisioning**  
   Deploy the infrastructure using the prepared configuration to ensure templates are working as expected.

3. **Infrastructure Teardown**  
   Clean up and destroy the provisioned infrastructure to validate proper teardown and avoid resource leakage.

