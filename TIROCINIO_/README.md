Simulazione LES Re=40000: U=0.4 m/s, ni=1e-5 m²/s, D=1 m, deltaT=0.0005s, durata=210s

NB: Prima di lanciare la simulazione occorre cambiare il parametro numberOfSubdomains nel file system/decomposeParDict e il parametro numberOfProcessors nel file run.sh, inserendo il numero di core del proprio Pc.

-Utilizza run.sh/clean.sh per lanciare la simulazione/ripulire la cartella post-simulazione.
-Utilizza CdeCl.ipynb per creare i grafici di Cl/Cd e y+, tramite i dati della cartella postProcessing che si crea post-simulazione.
-È presente un file Misure.ipynb che serve per creare i grafici con gli andamenti delle grandezze mediate, da t=100s a t=210s
