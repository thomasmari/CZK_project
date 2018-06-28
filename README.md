# CZK_project
#Access output 
	To access the already cumputed results
	The naming scheme used here for folders is 
	Output/t=TIMEOUT_KINDOFLAMBDA_EPSILON_KINDOFEPSILON/ENGINE
	where 
		TIMEOUT is the production timeout. In the D/M/1/n queue the arrival process is following the Dirac(TIMEOUT) 
			TIMEOUT is in seconds and should be written as [0-9]+.[0-9]+ 
			example : 0.1 
			The computed logs have all 0.1 for TIMEOUT 
		KINDOFLAMBDA is how is choosen the service time distribution rate. In the D/M/1/n queue the service distibution is EXP(LAMBDA)
			KINDOFLAMBDA is choosen in {regular,median}
				regular means that LAMBDA = 1/t
				median means that LAMBDA = ln(2)/t
		EPSILON is the wanted  precision of the computation, the expected form is 1E-[0-9]+ exemple : 1E-10
			in PRISM it is the terminaition epsilon in command line
			in Storm it is the --precision setting in command line
		KINDOFEPSILON is how is choosen the actual presision in the the command line computation on both PRISM and Storm
			KINDOFEPSILON is choosen in {constant,dynamic}
				constant means that the epsilon used in computation will be always EPSILON 
				dynamic means that the epsilon used in computation will changed with the value of PH fitting k as epsilon = EPSILON/k 
				The ACTMC results will always be in constant KINDOFEPSILON folder because this is not a PH fitting model

		ENGINE is the engine used for the computation
			ENGINE is choosen in {explicit,hybrid,storm}
				explicit is the ACTMC computation on PRISM-GSMP and also the PH fitting CTMC SSP computed by PRISM-GSMP with explicit engine 
				hybrid is the PH fitting CTMC SSP computed by PRISM with hybrid engine 
				hybrid is the PH fitting CTMC SSP computed by Storm with sparse engine 

	The naming scheme used for files depends on the type of results
		SSP results respect this naming scheme, 
		MODEL_N_K_EPSILON
		Where :
			MODEL is choosen in {ev,ph}
				ev for ACTMC model
				ph for PH fitting CTMC model
			N is the maximum capacity of the queue. In the D/M/1/n queue we have N=n
			K is the PH fitting parameter 
				for Ph fitting CTMC it is written as [0-9]+
				for ACTMC it is always k 
				EPSILON is the same as the EPSILON above in the folder naming scheme
			Those files contains the SSP results 
				for PH fitting model in explicit or hybrid folders the order used is the Lexicographical order(qSize,i) (this file should contain N*k lines)
				for PH fitting model in storm folder the order used is the Lexicographical order(qSize) (this file should contain N lines)
				for ACTMC the order used is the Lexicographical order(qSize) (this file should contain N lines)
		
		SSP computation logs respect this naming scheme
		MODEL_N_K_EPSILON.log
			The naming is the same for SSP results 
			Those files contains the logs for the computation, including command line and time of computation 
				
		SSP with post computation results respect this naming scheme, 
		sumph_N_K_EPSILON
		Where the naming scheme is the same that above 
		those files will be only in explicit and hybrid folders for PH fitting CTMC model
			Those files contains the sum of the SSP groupe by qSize which are display in the the Lexicographical order(qSize) 

		The following files are post computation used for the annalysis.   
		MODEL_k_array
			all PH fitting parameter k used in the folder order by increasing k
		
		MODEL_time_N
			all time of computation of the SSP in the folder order by increasing k

		MODEL_eps_array
			all exact epsilon used in computation used in the folder order by increasing k

