all:
	@echo "This is a dummy to prevent running make without explicit target!"

profenv-start:
	$(MAKE) -C test/ _profenv-start

profenv-stop:
	$(MAKE) -C test/ _profenv-stop
