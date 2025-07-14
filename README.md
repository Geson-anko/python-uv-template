# 🚀 Python UV Template

[![GitHub stars](https://img.shields.io/github/stars/Geson-anko/python-uv-template?style=social)](https://github.com/Geson-anko/python-uv-template/stargazers)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python Version](https://img.shields.io/badge/python-3.12+-blue.svg)](https://www.python.org/downloads/)
[![Format & Lint](https://github.com/Geson-anko/python-uv-template/actions/workflows/pre-commit.yml/badge.svg)](https://github.com/Geson-anko/python-uv-template/actions/workflows/pre-commit.yml)
[![Test](https://github.com/Geson-anko/python-uv-template/actions/workflows/test.yml/badge.svg)](https://github.com/Geson-anko/python-uv-template/actions/workflows/test.yml)
[![Type Check](https://github.com/Geson-anko/python-uv-template/actions/workflows/type-check.yaml/badge.svg)](https://github.com/Geson-anko/python-uv-template/actions/workflows/type-check.yaml)

**English** | [日本語](./README.ja.md)

> ✨ A modern Python project template using UV package manager for blazing fast dependency management

## 📋 Features

- 🐍 Python 3.12+ focused with type hints
- 🧪 Pre-configured pytest with coverage
- 🔍 Static type checking with pyright
- 🧹 Code formatting with ruff
- 🔄 CI/CD with GitHub Actions (separate workflows for pre-commit, tests, and type checking)
- 🐳 Docker and Docker Compose support for development environment
- 📦 UV package management for fast dependency resolution
- 📝 Pre-commit hooks for code quality
- 🏗️ Project structure following best practices

## 🛠️ Quick Start

### Create New Repository

[![Use this template](https://img.shields.io/badge/Use%20this%20template-2ea44f?style=for-the-badge)](https://github.com/new?template_name=python-uv-template&template_owner=Geson-anko)

### Clone and Setup

```bash
# Clone your new repository
git clone https://github.com/yourusername/your-new-repo.git
cd your-new-repo

# Run the interactive setup (Linux/macOS)
./setup.sh your-project-name

# Run the interactive setup (Windows)
.\Setup.ps1 your-project-name

# The setup script will:
# - Rename your project
# - Ask for your preferred language (English/Japanese)
# - Ask for your preferred build tool (Make/Just)
# - Clean up unnecessary files
# - Create a simple README template

# After setup, create virtual environment
make venv  # if you chose Make
# or
just venv  # if you chose Just
```

### Development Tools

You can use either `make` or `just` commands:

#### Using Make

```bash
# Run all checks (format, test, type check)
make run

# Format code
make format

# Run tests
make test

# Run type check
make type

# Clean up temporary files
make clean
```

#### Using Just

```bash
# Show available commands
just

# Run all checks (format, test, type check)
just run

# Format code
just format

# Run tests
just test

# Run type check
just type

# Clean up temporary files
just clean
```

### Docker Development

#### Using Make

```bash
# Build docker image
make docker-build

# Start development container
make docker-up

# Attach to development container
make docker-attach

# Stop containers
make docker-down

# Stop containers and remove volumes
make docker-down-volume

# Restart containers
make docker-restart
```

#### Using Just

```bash
# Build docker image
just docker-build

# Start development container
just docker-up

# Attach to development container
just docker-attach

# Stop containers
just docker-down

# Stop containers and remove volumes
just docker-down-volume

# Restart containers
just docker-restart
```

## 📂 Project Structure

```
.
├── .github/            # GitHub workflows and templates
│   └── workflows/
│       ├── pre-commit.yml    # Format & lint workflow
│       ├── test.yml          # Test workflow
│       └── type-check.yaml   # Type checking workflow
├── .vscode/            # VSCode configuration
│   └── extensions.json
├── src/
│   └── python_uv_template/  # Source code (will be renamed)
├── tests/              # Test files
├── .pre-commit-config.yaml
├── docker-compose.yml  # Docker Compose configuration
├── Dockerfile          # Docker image configuration
├── Makefile            # Development commands
├── pyproject.toml      # Project configuration
├── LICENSE
└── README.md
```

## 🏄‍♂️ Using Docker Environment

This project includes Docker configuration for consistent development environment.

1. Install [Docker](https://www.docker.com/products/docker-desktop) and [Docker Compose](https://docs.docker.com/compose/)
2. Build and start the development container:
   ```bash
   make docker-build
   make docker-up
   make docker-attach
   ```
3. The container includes all necessary tools and dependencies with proper shell completion

## 🧩 Dependencies

- Python 3.12+
- [UV](https://github.com/astral-sh/uv) - Modern Python package manager
- Development tools installed automatically via `make venv` or `just venv`
- Optional: [just](https://github.com/casey/just) - Command runner (alternative to make)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 🔧 Configuration

### GitHub Actions

The project includes three separate workflows:

- **pre-commit.yml**: Runs pre-commit hooks on all files
- **test.yml**: Runs tests on multiple OS and Python versions (3.12, 3.13)
- **type-check.yaml**: Runs pyright type checking

### pyproject.toml

- Configured for Python 3.12+
- Uses UV for dependency management
- Includes development dependencies for testing, linting, and type checking
- Coverage configuration excludes test files

## 🙏 Acknowledgements

- [UV](https://github.com/astral-sh/uv) for the blazing fast package management
- [ruff](https://github.com/astral-sh/ruff) for the powerful Python linter and formatter
- [pyright](https://github.com/microsoft/pyright) for static type checking
- [pre-commit](https://pre-commit.com/) for git hooks management
