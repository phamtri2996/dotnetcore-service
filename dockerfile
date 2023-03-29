FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY dotnetcore-service.csproj .
RUN dotnet restore "dotnetcore-service.csproj"
COPY . .
RUN dotnet build "dotnetcore-service.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "dotnetcore-service.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "dotnetcore-service.dll"]