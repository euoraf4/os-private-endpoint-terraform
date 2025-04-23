# Oracle Cloud Infrastructure (OCI) Object Storage - Bucket Configuration

Este arquivo **`readme.md`** descreve como configurar e provisionar buckets no **Oracle Cloud Infrastructure (OCI)** usando **Terraform**. A variável `private_endpoint_config` é responsável por definir as propriedades de cada bucket que será criado.

---

## Estrutura de `private_endpoint_config`

A variável `private_endpoint_config` é uma lista que pode conter um ou mais blocos de configuração para private_endpoint. Cada item desta lista representa a configuração de um private_endpoint específico.

### Parâmetros Principais

| Parâmetro               | Descrição                                                                                                                                              | Exemplo                             |
|-------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------|
| `name`                  | Nome do Private Endpoint a ser criado.                                                                                                                  | `"private-endpoint-001"`            |
| `compartment_name`      | Nome do compartimento onde o Private Endpoint será provisionado.                                                                                        | `"RafaelMelo"`                      |
| `subnet_id`             | OCID da subnet onde o Private Endpoint será criado.                                                                                                     | `"ocid1.subnet.oc1..example"`       |
| `prefix`                | Prefixo usado para os nomes DNS de acesso ao bucket através do endpoint privado.                                                                        | `"private-endpoint-001"`            |
| `access_targets`        | Lista de buckets que poderão ser acessados via o endpoint. Cada item deve conter `bucket_name` e `compartment_name`.                                   | `[ { bucket_name = "bucket-teste", compartment_name = "RafaelMelo" } ]` |
| `private_endpoint_ip`   | (Opcional) IP privado a ser atribuído ao endpoint. Se não informado, será atribuído automaticamente.                                                    | `"10.0.2.60"`                        |
| `additional_prefixes`   | (Opcional) Lista de prefixos DNS adicionais que serão associados ao endpoint, além do `prefix` principal.                                               | `[ "teste", "teste2" ]`             |
| `nsg_ids`               | (Opcional) Lista de OCIDs dos Network Security Groups (NSGs) aos quais o Private Endpoint será associado.                                              | `[ "ocid1.networksecuritygroup.oc1..example" ]` |

---

## Exemplo Completo

Abaixo está um exemplo de como definir a variável `private_endpoint_config` no seu arquivo **terraform.tfvars** ou em outro arquivo de variáveis:

```hcl
private_endpoint_config = [ 
    {
      # --- Required --- #
      name                  = "private-endpoint-001"
      compartment_name      = "RafaelMelo"
      subnet_id             = "ocid1.subnet.oc1.sa-saopaulo-1."
      prefix                = "private-endpoint-001"
      access_targets = [
        {
          bucket_name       = "bucket-teste00101010"
          compartment_name  = "RafaelMelo"
        }
      ]
      # --- Optional --- #
      private_endpoint_ip   = "10.0.2.60"
      additional_prefixes   = [ "teste", "teste2" ]
      nsg_ids               = [ "ocid1.networksecuritygroup.oc1.sa-saopaulo-1." ]
    }
]
```

---

# Defined Tags

## Estrutura de `defined_tags`

A variável `defined_tags` é um mapa utilizado para definir tags customizadas que serão associadas aos recursos. Essas tags ajudam a categorizar e identificar os recursos de forma padronizada.

| Chave                                          | Descrição                                                  | Exemplo                         |
|------------------------------------------------|------------------------------------------------------------|---------------------------------|
| `"SERVICES.created-by"`             | Identifica quem criou ou é responsável pelo recurso.       | `"SERVICES"`         |
| `"SERVICES.request-number"` | Número da solicitação de serviço (opcional, pode ser comentado). | `"R000XXXXX"`               |

---

# Backend Configuration para Armazenamento do State

Esta configuração no `main.tf` é utilizada **somente se você for armazenar os states do Terraform em um backend remoto**, como um bucket S3 (no caso, Oracle Cloud Object Storage).

## Parâmetros do Backend

| Parâmetro                    | Descrição                                                                                                                  | Exemplo                                                   |
|------------------------------|----------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------|
| `bucket`                     | Nome do bucket onde o state do Terraform será armazenado.                                                                | `"Terraform-files"`                                       |
| `region`                     | Região onde o bucket está localizado.                                                                                    | `"sa-saopaulo-1"`                                         |
| `profile`                    | Perfil de autenticação a ser utilizado.                                                                                  | `"default"`                                               |
| `key`                        | Caminho (dentro do bucket) para o arquivo do state.                                                                      | `"sample/tenancy_setup.tfstate"`                          |
| `shared_credentials_file`    | Arquivo de credenciais compartilhadas para autenticação.                                                                 | `"./key/credentials"`                                     |
| `skip_region_validation`     | Ignora a validação da região.                                                                                              | `true`                                                    |
| `skip_credentials_validation`| Ignora a validação das credenciais.                                                                                       | `true`                                                    |
| `skip_requesting_account_id` | Evita solicitar o ID da conta.                                                                                           | `true`                                                    |
| `use_path_style`             | Utiliza o estilo de caminho para acessar o bucket.                                                                       | `true`                                                    |
| `skip_s3_checksum`           | Ignora a verificação do checksum S3.                                                                                     | `true`                                                    |
| `skip_metadata_api_check`    | Ignora a verificação da API de metadata.                                                                                 | `true`                                                    |
| `endpoints`                  | Define endpoints personalizados para o serviço S3. **Atenção:** substitua `xxxxxxxxx` pelo namespace correto.               | `{ s3 = "https://xxxxxxxxx.compat.objectstorage.sa-saopaulo-1.oraclecloud.com" }` |

## Shared Credentials File

Para que o Terraform possa autenticar-se com o Oracle Cloud, é necessário fornecer um arquivo de credenciais compartilhadas. Siga os passos abaixo para criar e configurar o `shared_credentials_file`:

### Arquivo de Credenciais:**
   - Siga os seguintes steps e obtenha as credenciais: [Criando uma Criando uma chave secreta do cliente](https://docs.oracle.com/en-us/iaas/Content/Identity/access/to_create_a_Customer_Secret_key.htm)
   - Abra o arquivo ./key/credentials
   - Preencha **aws_access_key_id** e **aws_secret_access_key** com os dados coletados na console.

**Para mais detalhes, consulte a** [documentação oficial do Terraform para Object Storage State](https://docs.oracle.com/en-us/iaas/Content/dev/terraform/object-storage-state.htm).


## Como Obter o Namespace do Object Storage na Console

1. **Acesse o Console da Oracle Cloud:**  
   Entre na sua conta e acesse a área do Object Storage.

2. **Localize o Bucket:**  
   Selecione o bucket que você deseja utilizar ou crie um novo, se necessário.

3. **Visualize o Namespace:**  
   Na visão geral do bucket, localize o campo **Namespace**. Esse valor é único para a sua conta.

4. **Atualize a Configuração:**  
   Substitua o valor `xxxxxxxxx` no parâmetro `endpoints` pelo namespace obtido.

## Quando não for utilizar o remote state ou vai utilizar o OCI Resource Manager:

**Delete ou comente o seguinte bloco no arquivo main.tf**

```hcl
terraform {
  backend "s3" {
    #insecure = true
    bucket                        = "Terraform-files"
    region                        = "sa-saopaulo-1"
    profile                       = "default"
    key                           = "sample/tenancy_setup.tfstate"
    shared_credentials_file       = "./key/credentials"
    skip_region_validation        = true
    skip_credentials_validation   = true
    skip_requesting_account_id    = true
    use_path_style                = true
    skip_s3_checksum              = true
    skip_metadata_api_check       = true
    endpoints                     = { s3 = "https://xxxxxx.compat.objectstorage.sa-saopaulo-1.oraclecloud.com" } 
  }
}

```

---

## Como Executar

### Executando via OCI Resource Manager

1. Acesse o **OCI Console**.
2. Vá até **Resource Manager > Stacks**.
3. Crie um novo stack:
   - Faça upload do código Terraform em um arquivo `.zip`.
   - Especifique as variáveis no `terraform.tfvars`.
4. Execute o stack:
   - **Plan** para validar.
   - **Apply** para criar os recursos.

### Executando Localmente

Se preferir rodar localmente, adicione as variáveis no arquivo `terraform.tfvars` e execute os seguintes comandos:

```bash
tf init
tf plan
tf apply
```

Isso criará todos os recursos baseados no `terraform.tfvars` e nas configurações definidas. 