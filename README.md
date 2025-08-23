# AWS Baseline: VPC + EKS (Terraform)

Базовий шаблон для підняття **VPC** та **EKS** у AWS за допомогою офіційних модулів:
- `terraform-aws-modules/vpc/aws`
- `terraform-aws-modules/eks/aws`

Підтримується структура репозиторію:

/
├── backend.tf
├── main.tf
├── outputs.tf
├── terraform.tf
├── variables.tf
├── vpc/
│ ├── backend.tf
│ ├── main.tf
│ ├── outputs.tf
│ ├── terraform.tf
│ └── variables.tf
└── eks/
├── backend.tf
├── main.tf
├── outputs.tf
├── terraform.tf
└── variables.tf


> **Remote state:**  
> - VPC і EKS зберігають стан у S3 і (опц.) блокуються через DynamoDB.  
> - `eks` читає виходи `vpc` через `data.terraform_remote_state`.

---

## 🔧 Передумови

1. **Windows 10/11 + VS Code**
2. **Terraform CLI** ≥ 1.3  
   Перевірка: `terraform -version`
3. **AWS CLI v2**  
   Перевірка: `aws --version`
4. **kubectl** для керування кластером EKS  
   Перевірка: `kubectl version --client`
5. **AWS креденшали**  
   Налаштуйте профіль:
   ```powershell
   aws configure

