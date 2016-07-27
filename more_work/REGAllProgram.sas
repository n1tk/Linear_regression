ods noproctitle;
ods graphics / imagemap=on;

proc reg data=DATAREG.B4 alpha=0.05 plots(only)=(diagnostics residuals 
        partial(unpack) rstudentbypredicted observedbypredicted);
    model y=x1 x2 x3 x4 x5 x6 x7 x8 x9 / noint stb partial;
    output out=WORK.Reg_stats p=p_ lcl=lcl_ ucl=ucl_ lclm=lclm_ uclm=uclm_ 
        r=r_ student=student_ rstudent=rstudent_;
    run;
quit;