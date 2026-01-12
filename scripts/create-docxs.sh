#!/bin/bash

# Convert Formative Assessment Brief
quarto render d2/assessment-brief.qmd --to docx --output "TRAN5340M TDS Formative Assessment Brief.docx"

# Convert Summative Assessment Brief
quarto render d3/assessment-brief.qmd --to docx --output "TRAN5340M TDS Summative Assessment Brief.docx"
