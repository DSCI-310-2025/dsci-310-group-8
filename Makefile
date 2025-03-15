.PHONY: all clean report

all:
	make analysis/data/census+income/adult.data
	make analysis/data/clean_data.csv
	make analysis/output/final_model.rds
	make analysis/output/eda_summary.txt
	make clean
	make index.html

analysis/data/adult.data: source/01-download_data.R
	Rscript source/01-download_data.R --url="https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data" --output="analysis/data/census+income/adult.data"

analysis/data/clean_data.csv: source/02-clean_data.R analysis/data/census+income/adult.data
	Rscript source/02-clean_data.R --input_file=analysis/data/census+income/adult.data --output_file=analysis/data/clean_data.csv

analysis/output/eda_summary.txt: source/03-eda.R analysis/data/clean_data.csv
	Rscript source/03-eda.R --input_file=analysis/data/clean_data.csv --output_summary=analysis/output/eda_summary.txt

analysis/output/final_model.rds: source/04-model.R analysis/data/clean_data.csv
	Rscript source/04-model.R --input_file=analysis/data/clean_data.csv --output_model=analysis/output/final_model.rds

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
	rm -f index.html
	rm -f *.pdf