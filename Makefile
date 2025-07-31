# Makefile for md2docx tool

.PHONY: help install test clean demo

# Default target
help:
	@echo "md2docx - Markdown to DOCX Converter"
	@echo ""
	@echo "Available targets:"
	@echo "  help     - Show this help message"
	@echo "  install  - Install md2docx to ~/.local/bin"
	@echo "  test     - Run basic functionality tests"
	@echo "  demo     - Create demo output from sample.md"
	@echo "  clean    - Remove generated test files"
	@echo ""
	@echo "Requirements:"
	@echo "  - pandoc must be installed"
	@echo "  - Template file at share/pandoc/pandoc-template.docx (optional)"

# Install to user's local bin directory
install:
	@echo "Installing md2docx to ~/.local/bin..."
	@mkdir -p ~/.local/bin
	@cp md2docx ~/.local/bin/
	@chmod +x ~/.local/bin/md2docx
	@if [ -f pandoc-template.docx ]; then \
		cp pandoc-template.docx ~/.local/bin/; \
		echo "Template installed to ~/.local/bin/"; \
	else \
		echo "No template found - you can add one later to ~/.local/share/pandoc/pandoc-template.docx"; \
	fi
	@echo "Installation complete!"
	@echo "Make sure ~/.local/bin is in your PATH"

# Test basic functionality
test:
	@echo "Testing md2docx functionality..."
	@echo "1. Testing help option..."
	@./md2docx --help > /dev/null
	@echo "   ✅ Help option works"
	
	@echo "2. Testing stdin input..."
	@echo "# Test" | ./md2docx > test_output.docx
	@if [ -f test_output.docx ]; then \
		echo "   ✅ Stdin to file works"; \
		rm test_output.docx; \
	else \
		echo "   ❌ Stdin to file failed"; \
	fi
	
	@echo "3. Testing file input..."
	@./md2docx sample.md -o test_sample.docx
	@if [ -f test_sample.docx ]; then \
		echo "   ✅ File to file works"; \
		rm test_sample.docx; \
	else \
		echo "   ❌ File to file failed"; \
	fi
	
	@echo "4. Testing verbose mode..."
	@./md2docx sample.md -o test_verbose.docx -v 2>&1 | grep -q "INFO"
	@if [ $$? -eq 0 ]; then \
		echo "   ✅ Verbose mode works"; \
		rm -f test_verbose.docx; \
	else \
		echo "   ❌ Verbose mode failed"; \
	fi
	
	@echo "Tests completed!"

# Create demonstration output
demo:
	@echo "Creating demo output from sample.md..."
	@./md2docx sample.md -o sample_output.docx -v
	@echo "Demo created: sample_output.docx"

# Clean up test files
clean:
	@echo "Cleaning up test files..."
	@rm -f test_*.docx sample_output.docx
	@echo "Cleanup complete!"

# Check if pandoc is installed
check-deps:
	@echo "Checking dependencies..."
	@which pandoc > /dev/null || (echo "❌ pandoc not found - please install it" && exit 1)
	@echo "✅ pandoc found: $$(pandoc --version | head -n1)"
