~ = $(HOME)
project = $~/papers/2026-geom-iclr
slides = 

deps = $(shell perl hdeps.pl index.html)
targets = $(patsubst $(project)/$2/%.$3,static/$1/%.$(or $4,$3),$(wildcard $(project)/$2/*.$3))

all: $(deps) ;


ifdef slides
$(foreach idx,$(shell seq 1 $(words $(slides))), $(eval static/figures/$(word $(idx),$(slides)).pdf: build/slide$(idx).pdf))

$(foreach idx,$(shell seq 1 $(words $(slides))),%/slide$(idx).pdf): figures.key | build static/figures
	keysplit --crop $< $*
endif

slides: $(foreach fig,$(slides),static/figures/$(fig).pdf)

$(foreach fig,$(slides),static/figures/$(fig).pdf):
	cp $< $@

static/%.svg: static/%.pdf
	pdf2svg $< $@

static/%.png: static/%.pdf
	pdf2png $< $@

static/videos/%.png: static/videos/%.mp4
	ffmpeg -i $< -ss 00:00:01 -vframes 1 $@

static/%.png: static/%.pdf
	pdf2png $< $@

static/figures/%: $(project)/figures/%
	cp $< $@

static/figures/%: $(project)/../figures/%
	cp $< $@

static/figures/%: $(project)/figures/%
	mkdir -p $(@D)
	cp $< $@


$(call targets,figures,figures,pdf,svg): static/%: $(project)/%
$(call targets,figures,figures,pdf,svg): static/%: $(project)/%
$(call targets,figures,figures,pdf): static/%: $(project)/%
	cp $< $@

$(call targets,pdf,dist,pdf): static/pdf/%.pdf: $(project)/dist/%.pdf
	cp $< $@

build:
	mkdir -p $@

clean:
	rm -rf build
