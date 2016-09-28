PRO proc1
	PRINT, 'this is proc1'
END

PRO proc2
	PRINT, 'this is proc2'
END

PRO whileloop
	i = 10
	while (i GT 0) do begin
		print, i--
	endwhile
END
