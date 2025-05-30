#!/bin/bash

ACCOUNT_NAME=$1

SAS_TOKEN=$(az storage account generate-sas \
  --permissions "rwdlacu" \
  --account-name "$ACCOUNT_NAME" \
  --services t \
  --resource-types sco \
  --expiry 2026-12-31T23:59Z \
  --https-only \
  --output tsv)

# Return in JSON format for Terraform
echo "{\"sas\": \"$SAS_TOKEN\"}"
