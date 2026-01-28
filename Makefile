APP_MODELS_DIR := App/Models
PHINX_BIN := vendor/bin/phinx

MODEL_NAME := $(shell echo "$(MAKECMDGOALS)" | awk '{for(i=1;i<=NF;i++){if($$i=="--name"){print $$(i+1); exit}}}')
WITH_MIGRATION := $(filter --migration,$(MAKECMDGOALS))
FORCE_OVERWRITE := $(filter --force,$(MAKECMDGOALS))
ifneq (,$(filter model migration,$(MAKECMDGOALS)))
EXTRA_GOALS := $(filter-out model migration,$(MAKECMDGOALS))
.PHONY: $(EXTRA_GOALS)
$(EXTRA_GOALS):
	@:
endif

.PHONY: model
model:
	@if [ -z "$(MODEL_NAME)" ]; then echo "Usage: make model -- --name ModelName [--migration] [--force]"; exit 1; fi
	@if printf "%s" "$(MODEL_NAME)" | grep -q "[[:space:]]"; then echo "Model name must not contain spaces."; exit 1; fi
	@mkdir -p $(APP_MODELS_DIR)
	@model_file="$(APP_MODELS_DIR)/$(MODEL_NAME).php"; \
	table_base=$$(printf "%s" "$(MODEL_NAME)" | sed -E 's/([a-z0-9])([A-Z])/\1_\2/g' | tr '[:upper:]' '[:lower:]'); \
	case "$$table_base" in \
		*ch|*sh|*s|*x|*z) table_name="$${table_base}es" ;; \
		*y) table_name="$${table_base%y}ies" ;; \
		*) table_name="$${table_base}s" ;; \
	esac; \
	if [ -e "$$model_file" ] && [ -z "$(FORCE_OVERWRITE)" ]; then echo "Model already exists: $$model_file (use --force to overwrite)"; exit 1; fi; \
	printf "%s\n" "<?php" "" "namespace App\\Models;" "" "use ThePHPrame\\Core\\Library\\Model;" "" "class $(MODEL_NAME) extends Model" "{" "    protected \$$table = \"$$table_name\";" '    protected $$fillable = [];' '    protected $$softDeletes = false;' "}" > "$$model_file"; \
	echo "Created $$model_file"
	@if [ -n "$(WITH_MIGRATION)" ]; then \
		if [ -n "$(FORCE_OVERWRITE)" ]; then \
			snake_name=$$(printf "%s" "$(MODEL_NAME)" | sed -E 's/([a-z0-9])([A-Z])/\1_\2/g' | tr '[:upper:]' '[:lower:]'); \
			rm -f "Database/Migrations/"*"_create_$${snake_name}_table.php"; \
		fi; \
		$(PHINX_BIN) create Create$(MODEL_NAME)Table; \
		snake_name=$$(printf "%s" "$(MODEL_NAME)" | sed -E 's/([a-z0-9])([A-Z])/\1_\2/g' | tr '[:upper:]' '[:lower:]'); \
		table_base="$$snake_name"; \
		case "$$table_base" in \
			*ch|*sh|*s|*x|*z) table_name="$${table_base}es" ;; \
			*y) table_name="$${table_base%y}ies" ;; \
			*) table_name="$${table_base}s" ;; \
		esac; \
		migration_file=$$(ls -t Database/Migrations/*"_create_$${snake_name}_table.php" | head -n 1); \
		if [ -n "$$migration_file" ]; then \
			printf "%s\n" "<?php" "" "declare(strict_types=1);" "" "use Phinx\\Migration\\AbstractMigration;" "" "final class Create$(MODEL_NAME)Table extends AbstractMigration" "{" "    public function change(): void" "    {" '        $$table = $$this->table("'"$$table_name"'");' "    }" "}" > "$$migration_file"; \
		fi; \
	fi

.PHONY: migration
migration:
	@set -- $(MAKECMDGOALS); \
	while [ "$$1" ]; do \
		case "$$1" in \
			--) shift ;; \
			--model) model="$$2"; shift 2 ;; \
			--name) mig_name="$$2"; shift 2 ;; \
			--force) force=1; shift ;; \
			*) shift ;; \
		esac; \
	done; \
	if [ -z "$$model" ] || [ -z "$$mig_name" ]; then echo "Usage: make migration -- --model ModelName --name migrationName [--force]"; exit 1; fi; \
	if printf "%s" "$$model$$mig_name" | grep -q "[[:space:]]"; then echo "Model and migration name must not contain spaces."; exit 1; fi; \
	model_snake=$$(printf "%s" "$$model" | sed -E 's/([a-z0-9])([A-Z])/\1_\2/g' | tr '[:upper:]' '[:lower:]'); \
	name_snake=$$(printf "%s" "$$mig_name" | sed -E 's/[_-]+/ /g; s/([a-z0-9])([A-Z])/\1 \2/g' | tr '[:upper:]' '[:lower:]' | tr ' ' '_'); \
	case "$$model_snake" in \
		*ch|*sh|*s|*x|*z) table_name="$${model_snake}es" ;; \
		*y) table_name="$${model_snake%y}ies" ;; \
		*) table_name="$${model_snake}s" ;; \
	esac; \
	if [ -n "$$force" ]; then \
		rm -f "Database/Migrations/"*"_$${name_snake}_to_$${model_snake}.php"; \
	fi; \
	name_camel=$$(printf "%s" "$$mig_name" | sed -E 's/[_-]+/ /g; s/([a-z0-9])([A-Z])/\1 \2/g' | awk '{for(i=1;i<=NF;i++){ $$i=toupper(substr($$i,1,1)) substr($$i,2) } printf "%s",$0 }' | tr -d ' '); \
	$(PHINX_BIN) create Add$${name_camel}To$${model}; \
	migration_file=$$(ls -t Database/Migrations/*.php | head -n 1); \
	if [ -n "$$migration_file" ]; then \
		base_name=$$(basename "$$migration_file"); \
		prefix=$${base_name%%_*}; \
		target_file="Database/Migrations/$${prefix}_$${name_snake}_to_$${model_snake}.php"; \
		if [ "$$migration_file" != "$$target_file" ]; then \
			if [ -n "$$force" ]; then rm -f "$$target_file"; fi; \
			mv "$$migration_file" "$$target_file"; \
			migration_file="$$target_file"; \
		fi; \
	fi; \
	if [ -n "$$migration_file" ]; then \
		printf "%s\n" "<?php" "" "declare(strict_types=1);" "" "use Phinx\\Migration\\AbstractMigration;" "" "final class Add$${name_camel}To$${model} extends AbstractMigration" "{" "    public function change(): void" "    {" '        $$table = $$this->table("'"$$table_name"'");' "    }" "}" > "$$migration_file"; \
	fi
