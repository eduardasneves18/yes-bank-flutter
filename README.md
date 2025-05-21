# Yes-Bank (Flutter)

Yes-Bank é um aplicativo de gestão financeira simulado, desenvolvido em **Flutter** para dispositivos móveis. O app permite que os usuários registrem transações e consultem o extrato de suas operações, oferecendo uma experiência similar à de um banco digital ou aplicativo de controle financeiro pessoal. O foco está na **simplicidade** e nas funcionalidades essenciais para o gerenciamento das finanças.

## Funcionalidades

O sistema possui uma estrutura de login/logout que garante a segurança dos dados do usuário. Além disso:

- **Transações:** Permite registrar novas transações financeiras.
- **Extrato de transações:** O usuário pode consultar o histórico de transações realizadas.
- **Gráfico de transações:** O usuário tem uma visualização gráfica das transações realizadas por data.
- **Lazy loading:** Paginação implementada para melhor desempenho em listas longas.

## Tecnologias Utilizadas

- **Framework:** Flutter
- **Linguagem de programação:** Dart
- **Gerenciamento de estado:** Provider / MobX
- **Armazenamento de dados (simulado):** Local Storage
- **Cache:** `shared_preferences`
- **Segurança:** Firebase Auth (login/logout)
- **Lazy loading:** Estrutura de paginação para carregamento eficiente
- **Programação reativa:** foi utilizado o conceito de programaçõ reativa através da biblioteca MobX. A principal ideia por trás da reatividade no app é garantir que a interface do usuário responda automaticamente a mudanças nos dados, sem a necessidade de atualizações manuais.

## Pré-requisitos

Antes de rodar o projeto, é necessário ter o Flutter instalado. Siga as instruções na documentação oficial:

📎 https://docs.flutter.dev/get-started/install

## Instalação
Clone o repositório do projeto:

```bash
git clone https://github.com/eduardasneves18/yes-bank-flutter.git
```
Navegue até a pasta do projeto:

```bash
cd yes-bank-flutter
```
Instale as dependências:

```bash
flutter pub get
```
Execute o aplicativo:

```bash
flutter run
```
O app será iniciado em um emulador Android/iOS ou em um dispositivo físico conectado.

## Licença
Este projeto é de livre uso para fins de estudo e demonstração.
