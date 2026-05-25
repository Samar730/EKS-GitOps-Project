# EKS GitOps Platform | Production-Grade Kubernetes on AWS

![AWS](https://img.shields.io/badge/AWS-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![Helm](https://img.shields.io/badge/Helm-0F1689?style=for-the-badge&logo=helm&logoColor=white)
![ArgoCD](https://img.shields.io/badge/ArgoCD-EF7B4D?style=for-the-badge&logo=argo&logoColor=white)
![Traefik](https://img.shields.io/badge/Traefik-24A1C1?style=for-the-badge&logo=traefikproxy&logoColor=white)
![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/Grafana-F46800?style=for-the-badge&logo=grafana&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=githubactions&logoColor=white)
![CertManager](https://img.shields.io/badge/CertManager-003EFF?style=for-the-badge&logo=letsencrypt&logoColor=white)
![ExternalDNS](https://img.shields.io/badge/ExternalDNS-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)

A production-grade Kubernetes platform deployed on AWS EKS, provisioned with Terraform and managed through a GitOps workflow using ArgoCD. The platform hosts a self-hosted Memos note-taking application with automated CI/CD pipelines, full observability stack and zero static credentials.

## Architecture
![Architecture Diagram](docs/EKS-Memos-Architecture.png)