dotnet add package Microsoft.AspNetCore.Authentication.MicrosoftAccount --version 3.1.2
dotnet add package Microsoft.AspNetCore.Authentication.JwtBearer --version 3.1.2

dotnet add package Microsoft.EntityFrameworkCore.SqlServer --version 3.1.1
dotnet add reference ../Inspiration/Inspiration.csproj
dotnet tool install --global dotnet-ef
dotnet add package Microsoft.EntityFrameworkCore.Design

dotnet ef migrations add InitialCreate -o Data/Migrations

dotnet ef migrations add AddedTag
dotnet ef database update
dotnet ef migrations remove

dotnet ef migrations script --project "src\Infrastructure\Infrastructure.csproj" --output "src\Infrastructure\bin\db.sql"

az group deployment create -g starter-app-rg --template-file web-app.json --parameters @web-app-parameters.json 
az group deployment validate -g starter-app-rg --template-file redis-cache.json --parameters @redis-cache-parameters.json
az group deployment validate -g starter-app-rg --template-file sql-db.json --parameters @sql-db-parameters.json  
az group deployment validate -g starter-app-rg --template-file azure-search.json --parameters @azure-search-parameters.json 
az group deployment validate -g starter-app-rg --template-file key-vault-secrets.json --parameters @key-vault-secrets-parameters.json 
az group deployment validate -g starter-app-rg --template-file key-vault-policy.json --parameters @key-vault-policy-parameters.json 
az group deployment validate -g starter-app-rg --template-file storage-account.json --parameters @storage-account-parameters.json 
az group deployment create -g starter-app-rg --template-file link-template.json --parameters @link-template-parameters.json 
az group deployment validate -g starter-app-rg --template-file link-template.json --parameters @link-template-parameters.json 

az group deployment validate -g starter-app-rg \
    --template-file link-template.json \
    --parameters @link-template-parameters.json  \
    --parameters dbAdminAadObjectId=00000000-0000-0000-0000-000000000000

az group deployment create \
    -g MyResourceGroup \
    --template-uri https://raw.githubusercontent.com/bablulawrence/starter-react-dotnetcore-mvc/develop/src/Infrastructure/Cloud/Arm/link-template.json \
    --parameters https://raw.githubusercontent.com/bablulawrence/starter-react-dotnetcore-mvc/develop/src/Infrastructure/Cloud/Arm/link-template-parameters.json \
    --parameters dbAdminAadObjectId=00000000-0000-0000-0000-000000000000