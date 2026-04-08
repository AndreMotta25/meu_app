# CLAUDE.md — Flutter Mobile Project

## Visão Geral

Projeto Flutter mobile (Android + iOS) criado com:

```
flutter create --platforms=android,ios meu_app
```

Este arquivo define regras absolutas de arquitetura, nomenclatura e código.
**Não há espaço para improviso — siga todas as regras sem exceção.**

---

## Stack Obrigatória

| Responsabilidade        | Pacote                          |
| ----------------------- | ------------------------------- |
| Gerenciamento de estado | `flutter_riverpod`              |
| Injeção de dependências | `riverpod` (via providers)      |
| Navegação               | `go_router`                     |
| HTTP / API              | `dio`                           |
| Serialização JSON       | `freezed` + `json_serializable` |
| Armazenamento local     | `shared_preferences` ou `hive`  |
| Variáveis de ambiente   | `envied`                        |

> **Por que Riverpod?**
> É o gerenciador de estado mais moderno do ecossistema Flutter. Tem suporte
> nativo a null safety, é completamente type-safe, permite composição de
> providers sem `BuildContext`, e tem melhor testabilidade que Bloc e Provider.

---

## Estrutura de Pastas

```
lib/
├── core/
│   ├── constants/         # Strings, números e chaves globais
│   ├── errors/            # Classes de falha (Failure, AppException)
│   ├── extensions/        # Extensions em tipos nativos do Dart
│   ├── theme/             # AppTheme, AppColors, AppTextStyles, AppSpacing
│   └── utils/             # Funções utilitárias puras (sem estado)
│
├── features/
│   └── [feature_name]/
│       ├── data/
│       │   ├── datasources/   # Chamadas HTTP, banco local
│       │   ├── models/        # DTOs com fromJson/toJson (gerados por freezed)
│       │   └── repositories/  # Implementação concreta dos repositórios
│       ├── domain/
│       │   ├── entities/      # Objetos de domínio puros (sem dependência externa)
│       │   ├── repositories/  # Contratos abstratos (abstract interface)
│       │   └── usecases/      # Um caso de uso por arquivo
│       └── presentation/
│           ├── providers/     # Riverpod providers desta feature
│           ├── screens/       # Screens (uma por arquivo)
│           └── widgets/       # Widgets reutilizáveis desta feature
│
├── shared/
│   └── widgets/           # Widgets usados em mais de uma feature
│
└── main.dart
```

**Regras de estrutura:**

- Nunca colocar lógica de negócio em `presentation/`
- Nunca importar `data/` diretamente em `presentation/` — passe sempre pelo domínio
- `core/` não importa nada de `features/`
- `shared/widgets/` não importa providers de nenhuma feature

---

## Nomenclatura

### Arquivos

```
snake_case para todos os arquivos .dart

✅ user_profile_screen.dart
✅ auth_repository.dart
✅ get_user_usecase.dart
✅ app_colors.dart

❌ UserProfileScreen.dart
❌ authRepository.dart
```

### Classes

```
PascalCase para todas as classes

✅ UserProfileScreen
✅ AuthRepository
✅ GetUserUsecase
✅ AppColors
```

### Variáveis, funções e parâmetros

```
camelCase

✅ final userName = ...
✅ void fetchUser() {}
✅ Widget buildCard(String title) {}
```

### Constantes

```
camelCase (Dart moderno — não usar SCREAMING_SNAKE_CASE)

✅ const double defaultPadding = 16.0;
✅ const String apiBaseUrl = 'https://...';

❌ const double DEFAULT_PADDING = 16.0;
```

### Providers (Riverpod)

```
camelCase + sufixo "Provider"

✅ final authProvider = ...
✅ final userListProvider = ...
✅ final themeProvider = ...
```

---

## Regras Dart Obrigatórias

### Null Safety

- **Nunca usar `!` (bang operator) sem comentário justificando**
- Preferir `?.` e `??` para navegação e fallback seguro
- Usar `required` em todos os parâmetros obrigatórios de widgets e classes
- Nunca declarar variável como `dynamic` sem justificativa explícita

```dart
// ✅ Correto
final name = user?.name ?? 'Anônimo';

// ❌ Proibido sem justificativa
final name = user!.name;
```

### Tipagem

- Sempre tipar retornos de funções explicitamente
- Nunca usar `var` quando o tipo pode ser inferido e é relevante para legibilidade
- Usar `typedef` para tipos complexos repetidos

```dart
// ✅
String formatDate(DateTime date) { ... }
final List<User> users = [];

// ❌
formatDate(date) { ... }
var users = [];
```

### Imutabilidade

- Preferir `final` para todas as variáveis locais
- Usar `const` sempre que possível em widgets e valores
- Modelos de dados devem ser imutáveis via `freezed`

```dart
// ✅
const SizedBox(height: 16);
final user = ref.watch(userProvider);

// ❌
SizedBox(height: 16);  // sem const quando possível
var user = ref.watch(userProvider);
```

### Imports

- Sempre usar imports relativos dentro de `lib/`
- Agrupar na ordem: (1) dart:, (2) package:, (3) imports locais
- Nunca importar `barrel files` (index.dart) que reexportam tudo

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/user.dart';
```

---

## Design System

**Todo valor visual vem de `core/theme/`. Nunca usar valores hardcoded.**

### Cores

```dart
// ✅ Correto
color: AppColors.primary

// ❌ Proibido
color: Color(0xFF6200EE)
color: Colors.blue
```

### Espaçamento

```dart
// ✅ Correto
padding: EdgeInsets.all(AppSpacing.md)  // md = 16.0

// ❌ Proibido
padding: EdgeInsets.all(16)
padding: EdgeInsets.all(16.0)
```

### Tipografia

```dart
// ✅ Correto
style: AppTextStyles.bodyMedium

// ❌ Proibido
style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)
```

### Estrutura do tema

```dart
// core/theme/app_colors.dart
abstract final class AppColors {
  static const Color primary = Color(0xFF6200EE);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFF121212);
  // ...
}

// core/theme/app_spacing.dart
abstract final class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
}
```

---

## Arquitetura (Clean Architecture)

### Fluxo obrigatório

```
UI (Screen)
  └── Provider (Riverpod)
        └── UseCase (domain)
              └── Repository (contrato abstrato, domain)
                    └── RepositoryImpl (data)
                          └── DataSource (data)
```

### Regras de camada

**Domain** — zero dependências externas

- Entities: classes Dart puras, sem `fromJson`, sem Flutter
- Repositories: `abstract interface class`, nunca implementação
- UseCases: uma responsabilidade, método `call()` ou `execute()`

**Data** — implementação concreta

- Models estendem ou mapeiam Entities
- `RepositoryImpl` implementa o contrato do domain
- DataSources isolam Dio, SharedPreferences, etc.

**Presentation** — só consome, nunca processa regra de negócio

- Screens chamam providers
- Providers chamam UseCases
- Nunca chamar Repository diretamente da presentation

### Exemplo de UseCase

```dart
// features/auth/domain/usecases/sign_in_usecase.dart
final class SignInUsecase {
  const SignInUsecase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
  }) {
    return _repository.signIn(email: email, password: password);
  }
}
```

---

## Riverpod — Regras de Uso

- Usar `@riverpod` (geração de código) quando o projeto tiver `riverpod_generator`
- Preferir `AsyncNotifierProvider` para estado assíncrono
- Preferir `NotifierProvider` para estado síncrono com mutações
- Usar `Provider` somente para valores derivados ou dependências sem estado
- **Nunca usar `StateProvider` para lógica complexa** — use `NotifierProvider`
- Nunca fazer side-effects dentro de `build()` de um Notifier

```dart
// ✅ AsyncNotifierProvider para dados remotos
@riverpod
class UserList extends _$UserList {
  @override
  Future<List<User>> build() => ref.read(getUsersUsecaseProvider).call();
}
```

---

## Widgets

- Sempre `const` quando o widget não depende de estado
- Extrair widgets com mais de ~50 linhas para arquivo próprio
- Widgets de feature ficam em `features/[name]/presentation/widgets/`
- Widgets reutilizáveis entre features ficam em `shared/widgets/`
- Nunca usar `GlobalKey` sem necessidade explícita documentada

---

## Tratamento de Erros

### Princípio

Erros são valores — nunca use `try/catch` solto espalhado pelo código.
Todo erro previsível deve ser representado como um tipo, não como uma exceção voando pelo callstack.

### Pacote obrigatório

Adicionar `dartz` ao `pubspec.yaml` para o tipo `Either<Failure, T>`.

### Hierarquia de Failure

```dart
// core/errors/failures.dart

sealed class Failure {
  const Failure(this.message);
  final String message;
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Sem conexão com a internet.']);
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Erro no servidor. Tente novamente.']);
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Sessão expirada. Faça login novamente.']);
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Recurso não encontrado.']);
}

final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Erro ao acessar dados locais.']);
}

final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Erro inesperado. Tente novamente.']);
}
```

### Regras de uso do Either

**UseCases sempre retornam `Either<Failure, T>`:**

```dart
Future<Either<Failure, User>> call({required String email, required String password});
```

**RepositoryImpl captura exceções e converte em Failure:**

```dart
// ✅ Correto — exceção vira Failure tipado
@override
Future<Either<Failure, User>> signIn({
  required String email,
  required String password,
}) async {
  try {
    final result = await _dataSource.signIn(email: email, password: password);
    return Right(result.toEntity());
  } on UnauthorizedException {
    return const Left(UnauthorizedFailure());
  } on NetworkException {
    return const Left(NetworkFailure());
  } catch (_) {
    return const Left(UnknownFailure());
  }
}

// ❌ Proibido — nunca deixar exceção vazar para camadas acima
Future<User> signIn(...) async {
  final result = await _dataSource.signIn(...); // pode explodir
  return result.toEntity();
}
```

**Providers consomem o Either com fold ou pattern matching:**

```dart
// Usando fold
final result = await ref.read(signInUsecaseProvider).call(
  email: email,
  password: password,
);

result.fold(
  (failure) => state = AsyncError(failure.message, StackTrace.current),
  (user)    => state = AsyncData(user),
);
```

**Screens reagem ao estado de erro via AsyncValue:**

```dart
// ✅ Tratar os três estados sempre
ref.watch(authProvider).when(
  data:    (user)    => HomeScreen(user: user),
  loading: ()        => const LoadingWidget(),
  error:   (e, _)    => ErrorWidget(message: e.toString()),
);
```

### Regras obrigatórias

- `try/catch` **somente** em `RepositoryImpl` e `DataSource` — nunca em UseCase, Provider ou Screen
- Nunca fazer `catch (e)` sem tratar ou converter o erro
- Nunca usar `Exception` genérica — criar subclasses específicas em `core/errors/`
- `sealed class Failure` garante exhaustiveness — o compilador avisa se um caso não for tratado
- Mensagens de erro para o usuário ficam nas classes `Failure`, não espalhadas pela UI

---

## Navegação (go_router)

### Localização das rotas

```
lib/
└── core/
    └── router/
        ├── app_router.dart      # Configuração do GoRouter (provider)
        └── app_routes.dart      # Constantes com os paths
```

### Definição de paths — sempre constantes tipadas

```dart
// core/router/app_routes.dart
abstract final class AppRoutes {
  static const String splash    = '/';
  static const String login     = '/login';
  static const String home      = '/home';
  static const String profile   = '/home/profile';
  static const String settings  = '/home/settings';
}

// ✅ Navegar usando a constante
context.go(AppRoutes.home);

// ❌ Proibido — string hardcoded na navegação
context.go('/home');
```

### Configuração do router

```dart
// core/router/app_router.dart
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false, // true apenas em desenvolvimento
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (_, __, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (_, __) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
});
```

### Passagem de parâmetros

**Path params — para IDs e recursos:**

```dart
// Definição
GoRoute(
  path: '/products/:id',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return ProductScreen(id: id);
  },
)

// Navegação
context.go('/products/${product.id}');
```

**Extra — para objetos já carregados (evita refetch):**

```dart
// Navegação
context.go(AppRoutes.profile, extra: user);

// Recepção
builder: (context, state) {
  final user = state.extra as User;
  return ProfileScreen(user: user);
},
```

### Redirecionamento e proteção de rotas

```dart
// Dentro do GoRouter
redirect: (context, state) {
  final isAuthenticated = ref.read(authProvider).valueOrNull != null;
  final isOnLogin = state.matchedLocation == AppRoutes.login;

  if (!isAuthenticated && !isOnLogin) return AppRoutes.login;
  if (isAuthenticated && isOnLogin)  return AppRoutes.home;
  return null; // sem redirecionamento
},
```

### Métodos de navegação — quando usar cada um

| Método              | Quando usar                                           |
| ------------------- | ----------------------------------------------------- |
| `context.go()`      | Navegar substituindo o histórico (tabs, login → home) |
| `context.push()`    | Empilhar uma nova tela (detalhe, modal, form)         |
| `context.pop()`     | Voltar para a tela anterior                           |
| `context.replace()` | Substituir a tela atual sem voltar (splash → login)   |

### Regras obrigatórias

- Nunca usar `Navigator.push` ou `Navigator.pushNamed` — somente `go_router`
- Nunca hardcodar paths como string fora de `AppRoutes`
- `GoRouter` é configurado **uma vez** em `app_router.dart`, exposto via Riverpod provider
- Toda tela que exige autenticação é protegida via `redirect`, não via lógica dentro da Screen
- Nunca aninhar `GoRouter` — um único router para toda a aplicação

---

## O Que Claude Nunca Deve Fazer

- Criar lógica de negócio dentro de Screens ou Widgets
- Usar `setState` (usar Riverpod para todo estado)
- Hardcodar cores, espaçamentos ou estilos fora do design system
- Criar arquivos com nomes em PascalCase
- Usar `dynamic` sem comentário explicando o porquê
- Usar o operador `!` sem comentário justificando a segurança
- Misturar camadas (ex: importar `dio` direto em um UseCase)
- Criar um único arquivo com múltiplas classes públicas
- Ignorar `const` em widgets e valores que não mudam
- Usar `try/catch` fora de `RepositoryImpl` ou `DataSource`
- Retornar `void` ou lançar exceção em UseCase — sempre `Either<Failure, T>`
- Usar `Exception` genérica — criar subclasse específica em `core/errors/`
- Deixar erro sem tratamento (`catch (_) {}` vazio é proibido)
- Usar `Navigator.push` ou `Navigator.pushNamed` — somente `go_router`
- Hardcodar paths de navegação fora de `AppRoutes`
- Proteger rotas com lógica dentro da Screen — usar `redirect` no router
- Criar mais de um `GoRouter` na aplicação
