GREEN = \033[0;32m
YELLOW = \033[0;33m
BLUE = \033[0;34m
RESET = \033[0m

all: up

help:
	@echo "$(BLUE)Inception Project Makefile$(RESET)"
	@echo "$(YELLOW)Usage:$(RESET)"
	@echo "  make [target]"
	@echo ""
	@echo "$(YELLOW)Targets:$(RESET)"
	@echo "  $(GREEN)all$(RESET)       - Default: builds and starts containers"
	@echo "  $(GREEN)up$(RESET)        - Start containers in detached mode"
	@echo "  $(GREEN)build$(RESET)     - Build or rebuild containers"
	@echo "  $(GREEN)down$(RESET)      - Stop and remove containers"
	@echo "  $(GREEN)clean$(RESET)     - Remove containers, volumes, and networks"
	@echo "  $(GREEN)fclean$(RESET)    - Remove everything including images"
	@echo "  $(GREEN)re$(RESET)        - Rebuild everything from scratch"
	@echo "  $(GREEN)logs$(RESET)      - View container logs"
	@echo "  $(GREEN)ps$(RESET)        - List containers"
	@echo "  $(GREEN)wordpress$(RESET)  - Access WordPress container shell"
	@echo "  $(GREEN)mariadb$(RESET)    - Access MariaDB container shell"
	@echo "  $(GREEN)nginx$(RESET)      - Access Nginx container shell"
	@echo ""

build:
	@echo "$(GREEN)Building containers...$(RESET)"
	@docker compose build

up:
	@echo "$(GREEN)Starting containers...$(RESET)"
	@docker compose up -d

restart:
	@echo "$(GREEN)Restarting containers...$(RESET)"
	@docker compose restart

down:
	@echo "$(GREEN)Stopping containers...$(RESET)"
	@docker compose down

clean:
	@echo "$(YELLOW)Removing containers, networks, and volumes...$(RESET)"
	@docker compose down -v

fclean: clean
	@echo "$(YELLOW)Removing all related Docker images...$(RESET)"
	@docker rmi -f $$(docker images -q inception_* 2>/dev/null) 2>/dev/null || true

re: fclean build up
	@echo "$(GREEN)Rebuilt and started everything from scratch!$(RESET)"

logs:
	@echo "$(BLUE)Showing logs (press Ctrl+C to exit)...$(RESET)"
	@docker compose logs -f

ps:
	@echo "$(BLUE)Listing containers...$(RESET)"
	@docker compose ps

wordpress:
	@echo "$(GREEN)Accessing WordPress container...$(RESET)"
	@docker exec -it wordpress sh

mariadb:
	@echo "$(GREEN)Accessing MariaDB container...$(RESET)"
	@docker exec -it mariadb sh

nginx:
	@echo "$(GREEN)Accessing Nginx container...$(RESET)"
	@docker exec -it nginx sh

wp-admin:
	@echo "$(GREEN)Accessing WordPress admin...$(RESET)"
	@open https://mdekker.42.fr/wp-admin || \
	@xdg-open https://mdekker.42.fr/wp-admin || \
	@start https://mdekker.42.fr/wp-admin || \
	@echo "If the browser does not open, please visit:"
	@echo "https://mdekker.42.fr/wp-admin"

.PHONY: all help build up down restart clean fclean re logs ps wordpress mariadb nginx