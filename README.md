# md2docx - Markdown to DOCX Converter

A comprehensive command-line tool for converting Markdown files to Microsoft Word (DOCX) format using pandoc with customizable templates and flexible input/output options.

## Features

- **Flexible Input**: Accept input from stdin or file arguments
- **Flexible Output**: Write to stdout or specified output files
- **Template Support**: Use custom pandoc reference documents for styling
- **GitHub Flavored Markdown**: Full support for GFM syntax
- **Verbose Mode**: Detailed logging for debugging and monitoring
- **Additional Pandoc Args**: Pass through custom pandoc arguments
- **Error Handling**: Comprehensive error checking and user-friendly messages
- **Colorized Output**: Clear, colored log messages for better UX

## Installation

1. Ensure you have `pandoc` installed:
   ```bash
   # macOS
   brew install pandoc
   
   # Ubuntu/Debian
   sudo apt-get install pandoc
   
   # Or download from https://pandoc.org/installing.html
   ```

2. Place the `md2docx` script in your PATH or use it directly from this directory.

3. Place your pandoc reference document template `pandoc-template.docx` in the same folder as the script.

## Usage

### Basic Usage

```bash
# Convert from stdin to stdout
echo "# Hello World" | ./md2docx

# Convert file to stdout
./md2docx input.md

# Convert file to specific output
./md2docx input.md -o output.docx
```

### Advanced Usage

```bash
# Use custom template
./md2docx input.md -o output.docx -t custom-template.docx

# Verbose mode with additional pandoc options
./md2docx input.md -o output.docx -v --pandoc-args "--toc --number-sections"

# Convert multiple files using shell pipes
cat *.md | ./md2docx -o combined.docx
```

## Command Line Options

| Option | Description |
|--------|-------------|
| `-o, --output FILE` | Output file path (default: stdout) |
| `-t, --template FILE` | Custom pandoc reference document template |
| `-v, --verbose` | Enable verbose output |
| `-h, --help` | Show help message |
| `--pandoc-args ARGS` | Additional arguments to pass to pandoc |

## Template Setup

The tool expects a pandoc reference document template at:
```
share/pandoc/pandoc-template.docx
```

This template should be a properly formatted DOCX file that defines:
- Paragraph styles (Normal, Heading 1-6, etc.)
- Font settings
- Page layout and margins
- Header/footer configurations
- Color schemes

To create a template:
1. Create a DOCX file in Microsoft Word with your desired formatting
2. Save it as `pandoc-template.docx` in the `share/pandoc/` directory
3. The tool will automatically use this template for all conversions

## Supported Markdown Features

The tool supports GitHub Flavored Markdown (GFM), including:

- **Headers** (`# ## ###`)
- **Text Formatting** (*italic*, **bold**, ~~strikethrough~~)
- **Lists** (ordered and unordered)
- **Code Blocks** and `inline code`
- **Tables**
- **Links** and images
- **Blockquotes**
- **Line breaks** and paragraphs

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | General error |
| 2 | Missing dependencies |
| 3 | Invalid arguments |
| 4 | File not found |

## Examples

### Example 1: Simple Conversion
```bash
# Create a markdown file
echo "# My Document\n\nThis is a **bold** statement." > test.md

# Convert to DOCX
./md2docx test.md -o test.docx
```

### Example 2: Pipeline Usage
```bash
# Generate markdown content and convert in one command
curl -s https://raw.githubusercontent.com/user/repo/main/README.md | ./md2docx -o readme.docx
```

### Example 3: Advanced Formatting
```bash
# Convert with table of contents and section numbers
./md2docx input.md -o output.docx --pandoc-args "--toc --number-sections --toc-depth=3"
```

## Troubleshooting

### Common Issues

1. **"pandoc is not installed"**
   - Install pandoc using your system's package manager
   - Ensure pandoc is in your PATH

2. **"Template file not found"**
   - Create the template file at `share/pandoc/pandoc-template.docx`
   - Or specify a custom template with `-t` option

3. **"Permission denied"**
   - Make sure the script is executable: `chmod +x md2docx`
   - Check file permissions for input/output files

### Debug Mode

Use the `-v` flag for verbose output to see exactly what commands are being executed:

```bash
./md2docx input.md -o output.docx -v
```

## Contributing

This tool is designed to be simple, reliable, and extensible. Feel free to modify it for your specific needs.

## License

This tool is provided as-is for educational and productivity purposes.
