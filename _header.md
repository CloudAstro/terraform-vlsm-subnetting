# Terraform VLSM Subnetting Module

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md)[![Notice](https://img.shields.io/badge/notice-copyright-blue.svg)](NOTICE)[![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE)[![OpenTofu Registry](https://img.shields.io/badge/opentofu-registry-yellow.svg)](https://search.opentofu.org/module/cloudastro/vlsm/core/)

This Terraform module calculates subnet CIDR blocks using **Variable Length Subnet Masking (VLSM)** based on a user-defined base CIDR block. It is designed to support **any cloud provider** or on-premise network environment where CIDR-based subnetting is required.

## Features

- **VLSM-Based Subnetting**: Dynamically calculate subnets from a base CIDR using `newbits` and `netnum`.
- **Flexible Input Structure**: Define subnets using human-readable aliases and modular input blocks.
- **Cloud-Agnostic Design**: Use with AWS, Azure, GCP, or any platform requiring CIDR planning.
- **Structured Output**: Returns a nested map of subnet aliases and their computed CIDRs, ideal for consumption by other modules.

## Example Usage
