FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY ["MyDigitalOceanApp/MyDigitalOceanApp.csproj", "MyDigitalOceanApp/"]
RUN dotnet restore "MyDigitalOceanApp/MyDigitalOceanApp.csproj"
COPY . .
WORKDIR "/src/MyDigitalOceanApp"
RUN dotnet build "MyDigitalOceanApp.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "MyDigitalOceanApp.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "MyDigitalOceanApp.dll"]