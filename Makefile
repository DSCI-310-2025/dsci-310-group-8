# TODO: Change the following to use the new R script
# .PHONY: all clean reports

# TODO: Change the following to use the new R script
# all: results/horse_pop_plot_largest_sd.png \
# 	results/horse_pops_plot.png \
# 	results/horses_spread.csv \
# 	reports/qmd_example.html \
# 	reports/qmd_example.pdf \
# 	docs/index.html


# TODO: Change the following to use the new R script

# # generate figures and objects for report
# results/horse_pop_plot_largest_sd.png results/horse_pops_plot.png results/horses_spread.csv: source/generate_figures.R
# 	Rscript source/generate_figures.R --input_dir="data/00030067-eng.csv" \
# 		--out_dir="results"

# # render quarto report in HTML and PDF
# reports/qmd_example.html: results reports/qmd_example.qmd
# 	quarto render reports/qmd_example.qmd --to html

# reports/qmd_example.pdf: results reports/qmd_example.qmd
# 	quarto render reports/qmd_example.qmd --to pdf

# docs/index.html: reports/qmd_example.qmd
# 	mkdir -p docs
# 	quarto render reports/qmd_example.qmd --to html --output index.html
# 	mv index.html docs/index.html
# 	touch .nojekyll docs/.nojekyll

# reports:
# 	make index.html

# TODO: Change the following to use the new R script
# clean:
# 	rm -rf results
# 	rm -rf reports/qmd_example.html \
# 		reports/qmd_example.pdf \
# 		reports/qmd_example_files