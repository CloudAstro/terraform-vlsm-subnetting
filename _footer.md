## 🌐 Additional Information

This module provides a flexible, reusable solution for CIDR subnet planning using **Variable Length Subnet Masking (VLSM)**. It is cloud-agnostic and can be integrated with Terraform-based deployments across **AWS, Azure, GCP**, or **on-prem environments**. Ideal for teams that need deterministic and automated subnet allocation based on a single base CIDR.

## 📚 Resources

- [CIDR Subnetting Explained (RFC 4632)](https://datatracker.ietf.org/doc/html/rfc4632)
- [VLSM Overview](https://en.wikipedia.org/wiki/Variable-length_subnet_mask)
- [Terraform Language Documentation](https://developer.hashicorp.com/terraform/language)
- [OpenTofu (Terraform Fork) Registry](https://opentofu.org/)

## ⚠️ Notes

- The module does **not perform validation** on overlapping subnets — ensure your `newbits` and `netnum` combinations do not conflict.
- Intended to **calculate CIDRs only** — subnet creation (e.g., in Azure or AWS) should be handled by separate modules.
- Designed for use with **modular networking architectures** where subnet layout is dynamically generated.

## 🧾 License

This module is released under the **Apache 2.0 License**. See the [LICENSE](./LICENSE) file for full details.
