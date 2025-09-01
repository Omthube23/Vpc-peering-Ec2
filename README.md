# 🌐 Terraform Multi-VPC + EC2 Infrastructure

This repository contains a **Terraform project** that provisions:  
- Two **VPCs** (Production & Development)  
- Public and Private **Subnets**  
- Internet Gateway, NAT Gateway, and Route Tables  
- **VPC Peering** between Prod ↔ Dev  
- Security Groups (SSH open to world, ICMP between VPCs)  
- Two **EC2 Instances** (`t3.medium`), one in each VPC  

The code is fully modularized into `vpc/` and `ec2/` submodules, orchestrated by a root `main.tf`.

---

## 📂 Project Structure
```
vpcpeering-ec2-terraform/
├─ main.tf         # Root orchestrator (runs everything together)
├─ variables.tf    # Region + tags
├─ version.tf      # Terraform & provider version constraints
├─ vpc/            # VPC module (creates VPCs, subnets, NAT, SGs, peering)
│  ├─ main.tf
│  ├─ variables.tf
│  ├─ outputs.tf
│  └─ modules/
│     ├─ vpc/
│     ├─ security-group/
│     └─ vpc-peering/
└─ ec2/            # EC2 module (creates instances in subnets)
   ├─ main.tf
   ├─ variables.tf
   └─ outputs.tf
```

---

## 🏗️ Modules Explained

### 1. **VPC Module**
Creates **Prod** and **Dev** VPCs with:  
- Public & private subnets  
- Internet Gateway & NAT Gateway  
- Route Tables (public → IGW, private → NAT)  

**Outputs:**  
- `prod_public_subnet_id`, `dev_public_subnet_id`  
- `prod_sg_id`, `dev_sg_id`  
- `vpc_peering_connection_id`  

---

### 2. **Security Group Module**
- **SSH (22)** → open to `0.0.0.0/0` (anywhere)  
- **ICMP (ping)** → allowed only between Prod ↔ Dev VPC CIDRs  

This enables you to SSH from your local machine and ping between VPCs.

---

### 3. **VPC Peering Module**
Creates a **peering connection** between Prod ↔ Dev VPCs.  
Adds routes in all route tables so that private IPs in Prod can talk to Dev, and vice versa.

---

### 4. **EC2 Module**
Launches EC2 instances in the subnets provided:  
- Uses **Ubuntu AMI** (`ami-02d26659fd82cf299`)  
- Instance type: `t3.medium`  
- Associates a public IP  
- Key pair: `shubham` (default, can be overridden)  

**Outputs:**  
- `public_ip` → connect via SSH  
- `private_ip` → test connectivity between VPCs  

---

## ⚡ Orchestration with `depends_on`

The root `main.tf` wires everything together:  

```hcl
module "prod_ec2" {
  source             = "./ec2"
  name               = "prod-ec2"
  subnet_id          = module.vpc.prod_public_subnet_id
  security_group_ids = [module.vpc.prod_sg_id]
  tags               = var.tags

  depends_on = [module.vpc] # Ensures VPC is created before EC2
}
```

This way EC2 waits for the VPC, subnets, and SGs to be created.

---

## 🚀 How to Run

### 1️⃣ Clone and init
```bash
cd vpcpeering-ec2-terraform
terraform init
```

### 2️⃣ Apply the configuration
```bash
terraform apply
```

Terraform will:
1. Create Prod & Dev VPCs with subnets, NAT, IGW  
2. Create security groups and peering  
3. Launch EC2 instances (one in each VPC)  

---

## 🔑 Accessing EC2

- Default user: **ubuntu**  
- SSH example:
```bash
ssh -i shubham.pem ubuntu@<prod_ec2_public_ip>
ssh -i shubham.pem ubuntu@<dev_ec2_public_ip>
```

- Ping across VPCs using private IPs:
```bash
ping <dev_ec2_private_ip>  # from prod EC2
ping <prod_ec2_private_ip> # from dev EC2
```

---

## 🧹 Clean Up
To destroy everything:
```bash
terraform destroy
```

---

## 🎯 Key Features
- Modular design → reuse `vpc/` and `ec2/` modules anywhere  
- Safe provider pinning (`aws ~> 5.0`, Terraform >= 1.6.0)  
- Uses `depends_on` for proper resource ordering  
- Secure (ICMP limited, SSH configurable via keypair)  
- Demo-ready multi-VPC environment  
