# Makefile for md2docx and docx2md tools

.PHONY: help install test clean demo test-docx2md demo-docx2md

# Default target
help:
	@echo "md2docx & docx2md - Document Conversion Tools"
	@echo ""
	@echo "Available targets:"
	@echo "  help         - Show this help message"
	@echo "  install      - Install both tools to ~/.local/bin"
	@echo "  test         - Run basic functionality tests for both tools"
	@echo "  test-docx2md - Run tests specifically for docx2md"
	@echo "  demo         - Create demo output from sample.md using md2docx"
	@echo "  demo-docx2md - Create demo output by converting back to markdown"
	@echo "  clean        - Remove generated test files"
	@echo "  check-deps   - Check if pandoc is installed"
	@echo ""
	@echo "Requirements:"
	@echo "  - pandoc must be installed"
	@echo "  - Template file at share/pandoc/pandoc-template.docx (optional for md2docx)"

# Install to user's local bin directory
install:
	@echo "Installing md2docx and docx2md to ~/.local/bin..."
	@mkdir -p ~/.local/bin
	@cp md2docx ~/.local/bin/
	@cp docx2md ~/.local/bin/
	@chmod +x ~/.local/bin/md2docx
	@chmod +x ~/.local/bin/docx2md
	@if [ -f pandoc-template.docx ]; then \
		cp pandoc-template.docx ~/.local/bin/; \
		echo "Template installed to ~/.local/bin/"; \
	else \
		echo "No template found - you can add one later to ~/.local/share/pandoc/pandoc-template.docx"; \
	fi
	@echo "Installation complete!"
	@echo "Both md2docx and docx2md are now available in ~/.local/bin"
	@echo "Make sure ~/.local/bin is in your PATH"

# Test basic functionality
test:
	@echo "Testing md2docx and docx2md functionality..."
	@echo ""
	@echo "=== Testing md2docx ==="
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
	
	@echo ""
	@echo "=== Testing docx2md ==="
	@make test-docx2md
	
	@echo ""
	@echo "All tests completed!"

# Test docx2md specifically
test-docx2md:
	@echo "1. Testing docx2md help option..."
	@./docx2md --help > /dev/null
	@echo "   ✅ Help option works"
	
	@echo "2. Testing docx2md file conversion..."
	@if [ -f test_sample.docx ]; then \
		./docx2md test_sample.docx -o test_converted.md; \
		if [ -f test_converted.md ]; then \
			echo "   ✅ DOCX to Markdown conversion works"; \
			rm test_converted.md; \
		else \
			echo "   ❌ DOCX to Markdown conversion failed"; \
		fi; \
		rm test_sample.docx; \
	else \
		echo "   Creating test DOCX file first..."; \
		./md2docx sample.md -o test_temp.docx; \
		./docx2md test_temp.docx -o test_converted.md; \
		if [ -f test_converted.md ]; then \
			echo "   ✅ DOCX to Markdown conversion works"; \
			rm test_converted.md; \
		else \
			echo "   ❌ DOCX to Markdown conversion failed"; \
		fi; \
		rm -f test_temp.docx; \
	fi
	
	@echo "3. Testing docx2md verbose mode..."
	@./md2docx sample.md -o test_verbose_docx.docx > /dev/null 2>&1
	@./docx2md test_verbose_docx.docx -o test_verbose_md.md -v 2>&1 | grep -q "INFO"
	@if [ $$? -eq 0 ]; then \
		echo "   ✅ Verbose mode works"; \
		rm -f test_verbose_docx.docx test_verbose_md.md; \
	else \
		echo "   ❌ Verbose mode failed"; \
		rm -f test_verbose_docx.docx test_verbose_md.md; \
	fi

# Create demonstration output
demo:
	@echo "Creating demo output from sample.md using md2docx..."
	@./md2docx sample.md -o sample_output.docx -v
	@echo "Demo created: sample_output.docx"

# Create demonstration output for docx2md
demo-docx2md:
	@echo "Creating demo output using docx2md..."
	@if [ ! -f sample_output.docx ]; then \
		echo "Creating sample DOCX first..."; \
		./md2docx sample.md -o sample_output.docx; \
	fi
	@./docx2md sample_output.docx -o sample_converted.md -v
	@echo "Demo created: sample_converted.md"
	@echo "Round-trip conversion complete: sample.md -> sample_output.docx -> sample_converted.md"

# Clean up test files
clean:
	@echo "Cleaning up test files..."
	@rm -f test_*.docx test_*.md sample_output.docx sample_converted.md
	@echo "Cleanup complete!"

# Check if pandoc is installed
check-deps:
	@echo "Checking dependencies..."
	@which pandoc > /dev/null || (echo "❌ pandoc not found - please install it" && exit 1)
	@echo "✅ pandoc found: $$(pandoc --version | head -n1)"
