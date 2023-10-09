# Objetivos
- Entendimento sobre Infraestrutura como Código, Terraform e AWS Platform

- Entendimento sobre Terraform Core Workflow, Dependências, Providers

- Entendimento sobre HCL, Provisioners e States

- Entendimento sobre HCL avançado, Variables, e Environments

- Entendimento sobre Módulos, Backend, Workspace

- Entendimento Dependencias entre recursos e Comandos ( taint, grafos, graph, fmt, validate)

- Entendimento sobre Condições, Type Constraints, Laços e Blocos Dinâmicos

- Entendimento sobre Terraform Cloud e Terraform CLI

# Conteúdos

- Infraestrutura como Código

- Terraform e AWS Platform  

- Terraform Core Workflow e estrutura de Providers 

- HCL (arquivo de configuração), Variables e Environments

- Dependências e Comandos

- Condições, Types, Laços e Blocos Dinâmicos

- Terraform Cloud e Terraform CLI

- Link do projeto: https://docs.google.com/document/d/1_v6qQ_aNkHBmggvJyBVhGfeS4hHmsJAJE0cey12a7ys/edit?usp=sharing

Possíveis problemas

- Adicionar uma VPC para o Lamba
- Adicionar as dependências do código python no package da lambda
- Passar as variáveis do banco de dados para a Lambda

# Testing

- Terraform fmt — to format the code correctly.
- Terraform validate — to verify the syntax.
- Terraform plan — to verify the config file will work as expected.
- TFLint — to verify the contents of the configuration as well as the syntax and structure, also checks account limits (e.g. that a VM instance type is valid, and that the limit on the number of VMs in Azure has not been reached).
- Kitchen-Terraform — Kitchen-Terraform is an open-source tool that provides a framework for writing automated tests that validate the configuration and behavior of Terraform code, including testing for errors, resource creation, destruction, and validation of outputs. Kitchen-Terraform uses a combination of Ruby, Terraform, and Test Kitchen to spin up infrastructure in a sandbox environment, run tests, and destroy the infrastructure once testing is complete.
- Terratest — Terratest is an open-source testing framework for testing Terraform that can also be used to test Kubernetes, Docker, and Packer, amongst others. Terratest enables automated testing of infrastructure code in a sandbox environment to validate that it meets requirements, functions as expected, and is reliable. Tests are written in Go, and it provides a rich set of testing functions that allow the user to automate the entire testing process, including provisioning resources, running tests, and cleaning up resources. Terratest also provides built-in support for popular testing frameworks like Ginkgo and Gomega.


Links úteis:

- https://docs.aws.amazon.com/pt_br/lambda/latest/dg/python-package.html
