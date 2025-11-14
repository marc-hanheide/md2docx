# md2docx & docx2md - Document Conversion Tools

A comprehensive suite of command-line tools for converting between Markdown and Microsoft Word (DOCX) formats using pandoc with flexible input/output options.

## Tools Included

- **md2docx**: Convert Markdown files to DOCX format with customizable templates
- **docx2md**: Convert DOCX files to Markdown format

## Features

### md2docx Features
- **Flexible Input**: Accept input from stdin or file arguments
- **Flexible Output**: Write to stdout or specified output files
- **Template Support**: Use custom pandoc reference documents for styling
- **GitHub Flavored Markdown**: Full support for GFM syntax
- **Verbose Mode**: Detailed logging for debugging and monitoring
- **Additional Pandoc Args**: Pass through custom pandoc arguments
- **Error Handling**: Comprehensive error checking and user-friendly messages
- **Colorized Output**: Clear, colored log messages for better UX

### docx2md Features
- **Flexible Input**: Accept DOCX input from stdin or file arguments
- **Flexible Output**: Write Markdown to stdout or specified output files
- **GitHub Flavored Markdown Output**: Produces clean GFM-compatible markdown
- **Verbose Mode**: Detailed logging for debugging and monitoring
- **Additional Pandoc Args**: Pass through custom pandoc arguments (e.g., media extraction)
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

2. Place both the `md2docx` and `docx2md` scripts in your PATH or use them directly from this directory.

3. For `md2docx`: Place your pandoc reference document template `pandoc-template.docx` in the same folder as the scripts.

## Usage

### md2docx - Markdown to DOCX

#### Basic Usage

```bash
# Convert from stdin to stdout
echo "# Hello World" | ./md2docx

# Convert file to stdout
./md2docx input.md

# Convert file to specific output
./md2docx input.md -o output.docx
```

#### Advanced Usage

```bash
# Use custom template
./md2docx input.md -o output.docx -t custom-template.docx

# Verbose mode with additional pandoc options
./md2docx input.md -o output.docx -v --pandoc-args "--toc --number-sections"

# Convert multiple files using shell pipes
cat *.md | ./md2docx -o combined.docx
```

### docx2md - DOCX to Markdown

#### Basic Usage

```bash
# Convert from stdin to stdout
cat document.docx | ./docx2md

# Convert file to stdout
./docx2md input.docx

# Convert file to specific output
./docx2md input.docx -o output.md
```

#### Advanced Usage

```bash
# Verbose mode with media extraction
./docx2md input.docx -o output.md -v --pandoc-args "--extract-media=./media"

# Convert multiple files in a loop
for file in *.docx; do
    ./docx2md "$file" -o "${file%.docx}.md"
done
```

## Command Line Options

### md2docx Options

| Option | Description |
|--------|-------------|
| `-o, --output FILE` | Output file path (default: stdout) |
| `-t, --template FILE` | Custom pandoc reference document template |
| `-v, --verbose` | Enable verbose output |
| `-h, --help` | Show help message |
| `--pandoc-args ARGS` | Additional arguments to pass to pandoc |

### docx2md Options

| Option | Description |
|--------|-------------|
| `-o, --output FILE` | Output file path (default: stdout) |
| `-v, --verbose` | Enable verbose output |
| `-h, --help` | Show help message |
| `--pandoc-args ARGS` | Additional arguments to pass to pandoc |

## Template Setup (md2docx only)

The `md2docx` tool expects a pandoc reference document template at:
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
3. The `md2docx` tool will automatically use this template for all conversions

Note: The `docx2md` tool does not use templates as it converts from DOCX to Markdown.

## Supported Formats

### md2docx Input (Markdown Features)

The tool supports GitHub Flavored Markdown (GFM), including:

- **Headers** (`# ## ###`)
- **Text Formatting** (*italic*, **bold**, ~~strikethrough~~)
- **Lists** (ordered and unordered)
- **Code Blocks** and `inline code`
- **Tables**
- **Links** and images
- **Blockquotes**
- **Line breaks** and paragraphs

### docx2md Output (Markdown Features)

The tool outputs GitHub Flavored Markdown (GFM), preserving:

- **Headers** and document structure
- **Text Formatting** (bold, italic, strikethrough)
- **Lists** (ordered and unordered)
- **Code Blocks** and inline code
- **Tables**
- **Links** and images (with `--extract-media` option)
- **Blockquotes**
- **Paragraphs** and line breaks

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | General error |
| 2 | Missing dependencies |
| 3 | Invalid arguments |
| 4 | File not found |

## Examples

### Example 1: Markdown to DOCX
```bash
# Create a markdown file
echo "# My Document\n\nThis is a **bold** statement." > test.md

# Convert to DOCX
./md2docx test.md -o test.docx
```

### Example 2: DOCX to Markdown
```bash
# Convert DOCX to Markdown
./docx2md document.docx -o document.md

# Convert with media extraction
./docx2md document.docx -o document.md --pandoc-args "--extract-media=./images"
```

### Example 3: Pipeline Usage
```bash
# Generate markdown content and convert in one command
curl -s https://raw.githubusercontent.com/user/repo/main/README.md | ./md2docx -o readme.docx

# Convert DOCX back to markdown
./docx2md readme.docx -o readme_converted.md
```

### Example 4: Advanced Formatting
```bash
# Convert with table of contents and section numbers
./md2docx input.md -o output.docx --pandoc-args "--toc --number-sections --toc-depth=3"

# Convert DOCX preserving structure
./docx2md complex.docx -o output.md --pandoc-args "--wrap=none"
```

## Troubleshooting

### Common Issues

1. **"pandoc is not installed"**
   - Install pandoc using your system's package manager
   - Ensure pandoc is in your PATH

2. **"Template file not found"** (md2docx only)
   - Create the template file at `share/pandoc/pandoc-template.docx`
   - Or specify a custom template with `-t` option

3. **"Input file does not have .docx extension"** (docx2md only)
   - This is a warning - the tool will still attempt conversion
   - Ensure the input file is actually a valid DOCX file

4. **"Permission denied"**
   - Make sure the scripts are executable: `chmod +x md2docx docx2md`
   - Check file permissions for input/output files

### Debug Mode

Use the `-v` flag for verbose output to see exactly what commands are being executed:

```bash
./md2docx input.md -o output.docx -v
./docx2md input.docx -o output.md -v
```

## Contributing

These tools are designed to be simple, reliable, and extensible. Feel free to modify them for your specific needs.

## License

These tools are provided as-is for educational and productivity purposes.
