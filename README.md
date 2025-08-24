# AWS Baseline: VPC + EKS (Terraform)

Базовий шаблон для підняття **VPC** та **EKS** у AWS за допомогою офіційних модулів:
- `terraform-aws-modules/vpc/aws`
- `terraform-aws-modules/eks/aws`

### Структура репозиторію:

   ```
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
   ```

---

# EKS Cluster Deployment

Цей проєкт створює EKS кластер у AWS за допомогою Terraform.

---

# Попередні вимоги

1. Встановлений **Terraform ≥ 1.3.0**
2. Встановлений **AWS CLI v2**
3. Встановлений **kubectl**
4. Налаштований AWS профіль:
   ```bash
   aws configure

---
# Кроки запуску

1. Ініціалізація Terraform
   ```bash
   terraform init -upgrade

2. Перевірка конфігурації
   ```bash
   terraform validate

3. Перегляд плану змін
   ```bash
   terraform plan

4. Створення кластера
   ```bash
   terraform apply -auto-approve

5. Налаштування kubectl
   ```bash
   aws eks update-kubeconfig --name eks-baseline --region eu-central-1

6. Перевірте, що кластер створено:
   ```bash
   kubectl cluster-info
   kubectl get nodes
   kubectl get pods -n kube-system
   ```
   Ви маєте побачити обидві node group-и.