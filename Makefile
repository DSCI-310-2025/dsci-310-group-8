.PHONY: all clean report

all:
	make analysis/data/census+income/adult.data
	make analysis/data/clean_data.csv
	make analysis/output/eda_plot.png
	make analysis/output/final_model.rds
	make clean
	make index.html

analysis/data/census+income/adult.data: source/01-download_data.R | analysis/data/census+income
	Rscript source/01-download_data.R --url="https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data" --output="analysis/data/census+income/adult.data"

analysis/data/census+income:
	mkdir -p analysis/data/census+income

analysis/data/clean_data.csv: source/02-clean_data.R analysis/data/census+income/adult.data | analysis/data
	Rscript source/02-clean_data.R --input=analysis/data/census+income/adult.data --output=analysis/data/clean_data.csv

analysis/data:
	mkdir -p analysis/data

analysis/output/eda_plot.png: source/03-eda.R analysis/data/clean_data.csv | analysis/output
	Rscript source/03-eda.R --input=analysis/data/clean_data.csv --output=analysis/output/eda_plot.png

analysis/output/final_model.rds: source/04-model.R analysis/data/clean_data.csv | analysis/output
	Rscript source/04-model.R --input=analysis/data/clean_data.csv --output=analysis/output/final_model.rds

analysis/output:
	mkdir -p analysis/output

docs/index.html: analysis/report/report.qmd analysis/output/eda_summary.txt analysis/output/final_model.rds
	mkdir -p docs
	quarto render analysis/income-prediction-analysis.qmd --to html --output index.html
	mv index.html docs/index.html
	touch .nojekyll docs/.nojekyll

report:
	make index.html

clean:
	rm -f analysis/output/*
	rm -f analysis/data/clean/*
	rm -f docs/*
	rm -f *.pdf