variable "waf_prefix" {
  type        = string
  description = "Prefixo a ser usado ao nomear recursos"
  default     = "WAF"
}

variable "name" {
  type        = string
  description = "Nome para WebACL."
}

variable "scope" {
  type        = string
  description = "Escopo da web ACL: CLOUDFRONT, REGIONAL."
  default     = "REGIONAL"
}

variable "managed_rules" {
  type = list(object({
    name            = string
    priority        = number
    override_action = string
    excluded_rules  = list(string)
  }))
  description = "Lista de regras WAF."
  default = [
    {
      #Contém regras que são geralmente aplicáveis ​​a aplicações web. 
      #Isso fornece proteção contra a exploração de uma ampla gama de vulnerabilidades, 
      #incluindo aquelas descritas em publicações OWASP e Vulnerabilidades e exposições comuns comuns
      name            = "AWSManagedRulesCommonRuleSet",
      priority        = 10
      override_action = "none"
      excluded_rules  = []
    },
    {
      #Esse grupo contém regras baseadas na inteligência de ameaças da Amazon. 
      #Isso é útil se você deseja bloquear fontes associadas a bots ou outras ameaças.
      name            = "AWSManagedRulesAmazonIpReputationList",
      priority        = 20
      override_action = "none"
      excluded_rules  = []
    },
    {
      #Contém regras que permitem bloquear padrões de solicitação que são conhecidos como inválidos 
      #e estão associados à exploração ou descoberta de vulnerabilidades. 
      #Isso pode ajudar a reduzir o risco de um agente mal-intencionado descobrir um aplicativo vulnerável.
      name            = "AWSManagedRulesKnownBadInputsRuleSet",
      priority        = 30
      override_action = "none"
      excluded_rules  = []
    },
    {
      #Contém regras que permitem bloquear padrões de solicitação associados à exploração de bancos de dados SQL, 
      #como ataques de injeção de SQL. Isso pode ajudar a evitar a injeção remota de consultas não autorizadas.
      name            = "AWSManagedRulesSQLiRuleSet",
      priority        = 40
      override_action = "none"
      excluded_rules  = []
    },
    {
      #Contém regras que bloqueiam padrões de solicitação associados à exploração de vulnerabilidades
      #específicas do Linux, incluindo ataques LFI. Isso pode ajudar a evitar ataques que expõem 
      #o conteúdo do arquivo ou executam código ao qual o invasor não deveria ter acesso.
      name            = "AWSManagedRulesLinuxRuleSet",
      priority        = 50
      override_action = "none"
      excluded_rules  = []
    },
    {
      #Contém regras que bloqueiam padrões de solicitação associados à exploração de vulnerabilidades 
      #específicas de SO semelhante a POSIX/POSIX, incluindo ataques LFI. Isso pode ajudar a evitar 
      #ataques que expõem o conteúdo do arquivo ou executam código para o qual o acesso não deve ser permitido.
      name            = "AWSManagedRulesUnixRuleSet",
      priority        = 60
      override_action = "none"
      excluded_rules  = []
    }
  ]
}

variable "ip_sets_rule" {
  type = list(object({
    name       = string
    priority   = number
    ip_set_arn = string
    action     = string
  }))
  description = "Uma regra para detectar solicitações da Web provenientes de determinados endereços IP ou intervalos de endereços."
  default     = []
}

variable "ip_rate_based_rule" {
  type = object({
    name     = string
    priority = number
    limit    = number
    action   = string
  })
  description = "Uma regra baseada em taxa rastreia a taxa de solicitações para cada endereço IP de origem e aciona a ação da regra quando a taxa excede um limite especificado por você no número de solicitações em qualquer intervalo de tempo de 5 minutos"
  default     = null
}

variable "ip_rate_url_based_rules" {
  type = list(object({
    name                  = string
    priority              = number
    limit                 = number
    action                = string
    search_string         = string
    positional_constraint = string
  }))
  description = "Uma regra baseada em taxa e URL rastreia a taxa de solicitações para cada endereço IP de origem e aciona a ação da regra quando a taxa excede um limite especificado por você no número de solicitações em qualquer período de 5 minutos"
  default     = []
}

variable "filtered_header_rule" {
  type = object({
    header_types = list(string)
    priority     = number
    header_value = string
    action       = string
  })
  description = "Cabeçalho HTTP para filtrar. Atualmente suporta um único tipo de cabeçalho e vários valores de cabeçalho."
  default = {
    header_types = []
    priority     = 1
    header_value = ""
    action       = "block"
  }
}

variable "tags" {
  type        = map(string)
  description = "Um mapeamento de tags para atribuir à ACL WAFv2."
  default     = {}
}

variable "associate_alb" {
  type        = bool
  description = "Se deve associar um ALB à ACL WAFv2."
  default     = true
}

variable "alb_arn" {
  type        = string
  description = "ARN do ALB a ser associado à ACL WAFv2."
  default     = "arn:aws:elasticloadbalancing:us-east-2:068696838786:loadbalancer/app/lb-teste-waf/872859f265aa3367"
}

variable "group_rules" {
  type = list(object({
    name            = string
    arn             = string
    priority        = number
    override_action = string
    excluded_rules  = list(string)
  }))
  description = "Lista de grupos de regras WAFv2."
  default     = []
}

variable "default_action" {
  type        = string
  description = "A ação a ser executada se nenhuma das regras contidas na WebACL corresponder."
  default     = "block"
}

