FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS build
WORKDIR /app

## copy csproj and restore as distinct layers
COPY *.sln .
COPY test/*.csproj ./test/
RUN dotnet restore

## copy everything else and build app
COPY test/. ./test/
WORKDIR /app/test
RUN dotnet publish -c Release -o out


FROM mcr.microsoft.com/dotnet/core/aspnet:3.0 AS runtime
WORKDIR /app
COPY --from=build /app/test/out ./
ENTRYPOINT ["dotnet", "test.dll"]
