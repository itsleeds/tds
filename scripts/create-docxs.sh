#!/bin/bash

# Convert Formative Assessment Brief
quarto render d2/assessment-brief.qmd --to docx --output "TRAN5340M TDS Formative Assessment Brief.docx"

# Convert Summative Assessment Brief
quarto render d3/assessment-brief.qmd --to docx --output "TRAN5340M TDS Summative Assessment Brief.docx"

# Copy to OneDrive if it exists
DEST_DIR="/c/Users/georl/OneDrive - University of Leeds/career/modules/tds/2025-26"
if [ -d "$DEST_DIR" ]; then
    echo "Copying .docx files to $DEST_DIR"
    cp docs/*.docx "$DEST_DIR/"
fi
