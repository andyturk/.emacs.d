EMACS = /Applications/Emacs.app/Contents/MacOS/Emacs-x86_64-10_9

default : $(patsubst %.el,%.elc,$(wildcard *.el))

%.elc : %.el
	@echo Compiling $(<)
	@$(EMACS) --batch --eval $(subst FILE,$(<),'(byte-compile-file "FILE")')
