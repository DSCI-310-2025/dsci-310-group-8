.PHONY: all clean report

all: analysis/data/clean_data.csv analysis/output/eda_plot.png analysis/output/final_model.rds index.html

analysis/data/raw:
	mkdir -p analysis/data/raw

analysis/output:
	mkdir -p analysis/output

docs:
	mkdir -p docs

analysis/data/raw/adult.data: analysis/01-download_data.R | analysis/data/raw
	Rscript analysis/01-download_data.R --url="https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data" --output=analysis/data/raw/adult.data

analysis/data/clean_data.csv: analysis/02-clean_data.R analysis/data/raw/adult.data
	Rscript analysis/02-clean_data.R --input=analysis/data/raw/adult.data --output=analysis/data/clean_data.csv

analysis/output/eda_plot.png: analysis/03-eda.R analysis/data/clean_data.csv
	Rscript analysis/03-eda.R --input=analysis/data/clean_data.csv --output=analysis/output/eda_plot.png

analysis/output/final_model.rds: analysis/04-model.R analysis/data/clean_data.csv
	Rscript analysis/04-model.R --input=analysis/data/clean_data.csv --output=analysis/output/final_model.rds

index.html: report/report.qmd analysis/output/eda_plot.png analysis/output/final_model.rds docs
	quarto render report/report.qmd --to html
	mv report/report.html docs/index.html

clean:
	rm -f analysis/output/*
	rm -f analysis/data/clean/*
	rm -rf docs/*
	rm -f Rplots.pdf