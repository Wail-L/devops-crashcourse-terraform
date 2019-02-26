# Monter l'infra de recette sur AWS avec Terraform

Terraform permet de créer de manière programmable une infrastructure dans le Cloud pour notre application.

## Terraform - Infra as code

### Partie fournie

Nous fournissons une configuration partielle de l'infra.

- `vpc.tf` : création d'un réseau privé, découpé en 2 subnets
- `security_groups.tf` : création des règles de permissions de flux entre les ressources
- les variables sont définies dans chacun des fichiers Terraform, excéptées les variables partagées qui se trouvent dans `variables.tf`

### Partie à implémenter

Il nous reste à mettre en place les autres briques de l'infra.

- `frontends.tf` : création du load balancer et des serveurs frontend
- `backend.tf` : création de la base de données MySQL depuis un snapshot

Les variables à utiliser sont données dans ces 2 fichiers.

### Commandes Terraform

Une fois vos fichiers Terraform complétés, pour créer votre stack
```bash
terraform plan
terraform apply
```

Et pour détruire une stack Terraform
```bash
terraform destroy
```
