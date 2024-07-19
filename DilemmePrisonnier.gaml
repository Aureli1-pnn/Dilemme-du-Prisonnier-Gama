/**
* Name: DilemmePrisonnier
* Based on the internal empty template. 
* Author: Aurélien Pinon
* Tags: 
*/


model DilemmePrisonnier

/* Insert your model definition here */

global{
	// Nombre d'éléments par espèces
	int nb_accuse_initial;
	int nb_accuse_actuel;
	int nb_traitre      <- 5;
	int nb_indecis      <- 5;
	int nb_fidele       <- 5;
	int nb_revanchard   <- 5;
	int nb_rancunier    <- 5;
	int nb_girouette    <- 5;
	int nb_imitateur    <- 5;
	
	// Année de prison maximum
	int prison_max <- 150;
	
	// Statistiques par espèce
	int nb_mort_traitre        <- 0;
	int nb_match_traitre       <- 0;
	float annee_prison_traitre <- 0.0;
	float ratio_traitre        <- 0.0;
	
	int nb_mort_indecis		   <- 0;
	int nb_match_indecis       <- 0;
	float annee_prison_indecis <- 0.0;
	float ratio_indecis        <- 0.0;
	
	int nb_mort_fidele	      <- 0;
	int nb_match_fidele       <- 0;
	float annee_prison_fidele <- 0.0;
	float ratio_fidele		  <- 0.0;
	
	int nb_mort_revanchard 		  <- 0;
	int nb_match_revanchard       <- 0;
	float annee_prison_revanchard <- 0.0;
	float ratio_revanchard        <- 0.0;
	
	int nb_mort_rancunier 	     <- 0;
	int nb_match_rancunier       <- 0;
	float annee_prison_rancunier <- 0.0;
	float ratio_rancunier        <- 0.0;
	
	int nb_mort_girouette        <- 0;
	int nb_match_girouette       <- 0;
	float annee_prison_girouette <- 0.0;
	float ratio_girouette        <- 0.0;
	
	int nb_mort_imitateur  	     <- 0;
	int nb_match_imitateur       <- 0;
	float annee_prison_imitateur <- 0.0;
	float ratio_imitateur 	     <- 0.0;
	
	// Statistiques globales
	int nb_mort         <- 0;
	int nb_match        <- 0;
	float prison_totale <- 0.0;
	float condamnation_moyenne <- 0.0;
	
	// Liste contenant tous les accusés
	list<Accuse> list_accuse;
	list<int>    list_mort;
	
	// Mode de reproduction
	bool reproduction_un     <- false;
	bool reproduction_deux   <- false;
	bool reproduction_trois  <- false;
	bool reproduction_quatre <- true;
	int mode_reproduction <- 4;
	
	// Dispersion des agents
	bool dispersion <- false;
	
	// Effectué au début de la simulation
	init{
		// Calcul du nombre total d'agent 
		nb_accuse_initial <- nb_traitre + nb_indecis + nb_fidele + nb_revanchard + nb_rancunier + nb_girouette + nb_imitateur;
		nb_accuse_actuel  <- nb_accuse_initial;
	
		// Création des agents
		int index <- 0;  // Variable servant à donner une identité aux agents
		if nb_traitre > 0{
			loop i from:1 to: nb_traitre { 
				create Traitre number: 1 with: (identite: index, total_accuse: nb_accuse_initial);
				index <- index + 1;
			}
		}
		if nb_indecis > 0{
			loop i from:1 to: nb_indecis { 
				create Indecis number: 1 with: (identite: index, total_accuse: nb_accuse_initial);
				index <- index + 1;
			}
		} 
		if nb_fidele > 0{
			loop i from:1 to: nb_fidele { 
				create Fidele number: 1 with: (identite: index, total_accuse: nb_accuse_initial);
				index <- index + 1;
			}
		}
		if nb_revanchard > 0{
			loop i from:1 to: nb_revanchard { 
				create Revanchard number: 1 with: (identite: index, total_accuse: nb_accuse_initial);
				index <- index + 1;
			}
		}
		if nb_rancunier > 0{
			loop i from:1 to: nb_rancunier { 
				create Rancunier number: 1 with: (identite: index, total_accuse: nb_accuse_initial);
				index <- index + 1;
			}
		}
		if nb_girouette > 0{
			loop i from:1 to: nb_girouette { 
				create Girouette number: 1 with: (identite: index, total_accuse: nb_accuse_initial);
				index <- index + 1;
			}
		}
		if nb_imitateur > 0{
			loop i from:1 to: nb_imitateur { 
				create Imitateur number: 1 with: (identite: index, total_accuse: nb_accuse_initial);
				index <- index + 1;
			}	
		}
		
		// Initialisation du mode de reproduction
		if reproduction_un     { mode_reproduction <- 1;}
		if reproduction_deux   { mode_reproduction <- 2;}
		if reproduction_trois  { mode_reproduction <- 3;}
		if reproduction_quatre { mode_reproduction <- 4;}
	}
	
	// Met à jours les compteurs d'agents
	reflex maj_nb_accuse{
		nb_traitre       <- length(Traitre);
		nb_indecis       <- length(Indecis);
		nb_fidele        <- length(Fidele);
		nb_revanchard    <- length(Revanchard);
		nb_rancunier     <- length(Rancunier);
		nb_girouette     <- length(Girouette);	
		nb_imitateur     <- length(Imitateur);
		nb_accuse_actuel <- nb_traitre + nb_indecis + nb_fidele + nb_revanchard + nb_rancunier + nb_girouette + nb_imitateur;
	}
	
	// S'éxécute uniquement s'il y a eu des morts lors du tour précédent
	reflex reproduction when: nb_accuse_actuel < nb_accuse_initial {
				
		// Récupère la liste de tous les agents
		list_accuse         <- get_all_instances(Accuse);
		int nb_total_accuse <- length(list_accuse);
		
		// Récupère les identités à recréer 
		list_mort <- liste_des_morts(nb_total_accuse);
		
		// Mélange la liste (Utile s'il y'a égalité entre plusieurs agents sans mélange le premier type détécté serais toujours le même et par conséquent avantagé)
		loop i from:1 to:10{ list_accuse <- melange_aleatoire(list_accuse);	}
		
		// Détermine le nombre d'accusé à créer
		int nb_accuse_a_creer <- nb_accuse_initial - nb_total_accuse;
		nb_mort <- nb_mort + nb_accuse_a_creer;
		
		// Crée les accusé en fonction du mode de reproduction choisi lors de l'initialisation
		if(nb_accuse_a_creer > 0){
			if mode_reproduction = 1{
				write "Reproduction du meilleur accuse";
				do reproduction_du_meilleur_accuse(nb_accuse_a_creer);
			} 
			else if mode_reproduction = 2 {
				write "Reproduction aléatoire parmis les 10% meilleurs accusé";
				do reproduction_par_list_meilleurs_agents(nb_accuse_a_creer);
			}
			else if mode_reproduction = 3 {
				write "Reproduction aléatoire parmis tous les meilleurs accusé";
				do reproduction_par_meilleur_ratio_accuse(nb_accuse_a_creer);
			}
			else{
				write "Reproduction de la classe ayant le meilleur ratio global";
				do reproduction_par_meilleur_ratio_de_classe(nb_accuse_a_creer);
			}
		}
	}
	
	// La simulation s'arrête lorsqu'un type de stratégie est présent à au moins 75%
	reflex stop when: (nb_traitre    >= nb_accuse_initial*0.75 or 
					   nb_indecis    >= nb_accuse_initial*0.75 or 
					   nb_fidele     >= nb_accuse_initial*0.75 or   
					   nb_revanchard >= nb_accuse_initial*0.75 or      
					   nb_rancunier  >= nb_accuse_initial*0.75 or
					   nb_girouette  >= nb_accuse_initial*0.75 or
					   nb_imitateur  >= nb_accuse_initial*0.75 ) {
		write "Fin de simulation";
		do pause;
	}
	
	// ***** Méthodes ***** // 
	
	/* Modes de reproduction */
	action reproduction_du_meilleur_accuse(int nb_creation){
		/*
		 * REPRODUCTION 1 
		 * Cherche le type du meilleur agent pour le reproduire
		*/
		
		// Variables temporaires servant à déterminer la classe du meilleure agent
		float  ratio_meilleur_joueur  <- 100.0;
		string strategie_meilleur_joueur;
				
		// Parcours de tous les agents à la fin de la boucle la classe à reproduire sera contenu dans strategie_meilleur_joueur
		loop accuse over: list_accuse{
					
			// Récupération des données de chaque agent
			int nb_interrogatoire <- accuse.nb_interrogatoire;
			float nb_annee_prison <- accuse.nb_annee_prison;
			string classe_accuse  <- accuse.type;
			
			// On prend en compte seulement les accusés ayant effectué au minimum 5 interrogatoires
			if nb_interrogatoire > 5{
				float ratio <- nb_annee_prison / nb_interrogatoire; // Calcul du ratio
				// Comparaison avec le meilleur agent actuel
				if ratio < ratio_meilleur_joueur{
					// Mise à jour des valeurs
					ratio_meilleur_joueur     <- ratio;
					strategie_meilleur_joueur <- classe_accuse; 
				}
			}	
		}
		
		// Création du nombre d'agent requis		
		loop i from: 1 to: nb_creation{
		
			// Récupération de l'identité d'un des agents mort au tour précédent			
			int identite_a_creer  <- list_mort[i-1]; 
			
			// Création de l'agent
			do creer_nouvel_accuse(strategie_meilleur_joueur, identite_a_creer);
		}
	}
		
	action reproduction_par_list_meilleurs_agents(int nb_creation){
		/* 
	     * REPRODUCTION 2 
		 * Cherches les 10% meilleurs agents et sélectionne un type au hasard parmis ces derniers pour la reproduction
		 * 
		*/
		
		// ***** Crée une liste de pair <'nom_classe', ratio:prison/match> ***** //
		list<pair<string, float>> classement_agents <- [];
			
		// Parcours tous les agents, calcul pour chaque leur ratio et enregistre le résultat dans classement_agents
		loop accuse over: list_accuse{
	
			// Récupération des données de chaque agent
			int nb_interrogatoire <- accuse.nb_interrogatoire;
			float nb_annee_prison <- accuse.nb_annee_prison;
			string classe_accuse  <- accuse.type;
				
			// On prend en compte seulement les accusés ayant effectué au minimum 5 interrogatoires
			if nb_interrogatoire > 5 {
				// Enregistrement
				float ratio <- nb_annee_prison/nb_interrogatoire;
				add classe_accuse::ratio to: classement_agents;	
			}
		}
			
		// ***** Trie la liste en ordre croissant des ratios ***** //
		int min;
		int taille_classement <- length(classement_agents);
		pair<string, float> temp;
			
		loop i from: 0 to: taille_classement-1{
			min <- i;
			loop j from: i to: taille_classement-1{
				if classement_agents[j].value < classement_agents[min].value{
					min <- j;
				}
			}
			temp <- classement_agents[i];
			classement_agents[i] <- classement_agents[min];
			classement_agents[min] <- temp;
		}
			
		// ***** Pour chaque Agent a créer, choisi une classe au hasard parmis les 10% meilleurs agents ***** // 		
		loop i from: 1 to: nb_creation{
							
			// Choix de la classe 
			int identite_a_creer  <- list_mort[i-1]; // Récupération de l'identité d'un des agents mort au tour précédent
			string classe_a_creer <- "";
			if taille_classement < int(nb_accuse_initial*0.1){
				classe_a_creer <- classement_agents[rnd(taille_classement-1)].key;	
			}else{
				classe_a_creer <- classement_agents[int(nb_accuse_initial*0.1)-1].key;	
			}
			
			// Création de l'agent
			do creer_nouvel_accuse(classe_a_creer, identite_a_creer);
		}
	}
	
	action reproduction_par_meilleur_ratio_accuse(int nb_creation){
		/* 
		 * REPRODUCTION 3
		 * Cherches tous les agents ayant le meilleur ratio et sélectionne un type au hasard parmis ces derniers pour la reproduction
		 * 
		*/
			
		// ***** Crée une liste de pair <'nom_classe', ratio:prison/match> ***** //
		list<pair<string, float>> classement_agents <- [];
			
		// Parcours tous les agents, calcul pour chaque leur ratio et enregistre le résultat dans classement_agents
		loop accuse over: list_accuse{
		
			// Récupération des données de chaque agent
			int nb_interrogatoire <- accuse.nb_interrogatoire;
			float nb_annee_prison <- accuse.nb_annee_prison;
			string classe_accuse  <- accuse.type;
				
			// On prend en compte seulement les accusés ayant effectué au minimum 5 interrogatoires
			if nb_interrogatoire >= 5 {
				// Création de la paire classe/ratio
				float ratio               <- nb_annee_prison/nb_interrogatoire;
				pair<string, float> paire <- classe_accuse::ratio;
					
				// Enregistrement
				if length(classement_agents) = 0 or ratio = classement_agents[0].value{
					add paire to: classement_agents;						
				}
				else if ratio < classement_agents[0].value{
					classement_agents <- [paire];
				}
			}
		}
		
		// ***** Pour chaque Agent a créer, choisi une classe au hasard parmis les meilleurs agents ***** // 
		int taille_classement <- length(classement_agents);		
		loop i from: 1 to: nb_creation{				
			// Choix de la classe 
			int identite_a_creer  <- list_mort[i-1]; // Récupération de l'identité d'un des agents mort au tour précédent
			string classe_a_creer <- "";
			classe_a_creer <- classement_agents[rnd(taille_classement-1)].key;	
			
			// Création de l'agent
			do creer_nouvel_accuse(classe_a_creer, identite_a_creer);
		}
	}
	
	action reproduction_par_meilleur_ratio_de_classe(int nb_creation){
		/* 
		 * REPRODUCTION 4
		 * Reproduit l'espèce avec le meilleur "ratio_espece" parmis les variables globales
		 * 
		*/
			
		// ***** Pour chaque Agent a créer, reproduit la classe au meilleur ratio ***** // 	
		list<pair<string, float>> list_ratio <- [];
		if nb_traitre    > 0 { add 'Traitre'   ::ratio_traitre    to: list_ratio; }
		if nb_indecis    > 0 { add 'Indecis'   ::ratio_indecis    to: list_ratio; }
		if nb_fidele     > 0 { add 'Fidele'    ::ratio_fidele     to: list_ratio; }
		if nb_rancunier  > 0 { add 'Rancunier' ::ratio_rancunier  to: list_ratio; }
		if nb_revanchard > 0 { add 'Revanchard'::ratio_revanchard to: list_ratio; }
		if nb_girouette  > 0 { add 'Girouette' ::ratio_girouette  to: list_ratio; }
		if nb_imitateur  > 0 { add 'Imitateur' ::ratio_imitateur  to: list_ratio; }
			
		list_ratio <- melange_aleatoire_list_paire(list_ratio);
			
		string classe_a_creer  <- "";
		float  meilleure_ratio <- 100.0;
		loop paire over: list_ratio{
			if paire.value < meilleure_ratio{
				classe_a_creer  <- paire.key;
				meilleure_ratio <- paire.value;
			}
		}
		
		loop i from: 1 to: nb_creation{
			// Récupération de l'identité d'un des agents mort au tour précédent			
			int identite_a_creer  <- list_mort[i-1]; 
			
			// Création de l'agent
			do creer_nouvel_accuse(classe_a_creer, identite_a_creer);
		}
	}
	
	// Création d'un nouvel accusé determiné par la reproduction
	action creer_nouvel_accuse(string classe_a_creer, int identite){
		// Création de l'agent
		if      classe_a_creer = 'Traitre'   { create Traitre    number: 1 with: (identite: identite , total_accuse: nb_accuse_initial); }
		else if classe_a_creer = 'Indecis'   { create Indecis    number: 1 with: (identite: identite , total_accuse: nb_accuse_initial); }
		else if classe_a_creer = 'Fidele'    { create Fidele     number: 1 with: (identite: identite , total_accuse: nb_accuse_initial); }
		else if classe_a_creer = 'Rancunier' { create Rancunier  number: 1 with: (identite: identite , total_accuse: nb_accuse_initial); }
		else if classe_a_creer = 'Revanchard'{ create Revanchard number: 1 with: (identite: identite , total_accuse: nb_accuse_initial); }
		else if classe_a_creer = 'Girouette' { create Girouette  number: 1 with: (identite: identite , total_accuse: nb_accuse_initial); }
		else if classe_a_creer = 'Imitateur' { create Imitateur  number: 1 with: (identite: identite , total_accuse: nb_accuse_initial); }
	
		// Remise à zéro des mémoires de trahison pour l'agent créer 
		loop accuse over: list_accuse{ 
			accuse.memoire_nb_trahison[identite]     <- 0;
			accuse.memoire_nb_match[identite]        <- 0;
			accuse.memoire_derniere_action[identite] <- flip(0.5);
		}
	}
	
	/* Autres méthodes */
	
	// Mélange aléatoirement une liste d'Accuse
	list<Accuse> melange_aleatoire(list<Accuse> l){
		
		int    index_aleatoire;
		Accuse temp;
		
		loop i from: length(l)-1 to: 1{
			// Génération d'un index aléatoire
			index_aleatoire <- rnd(0, i);
			
			// Echange entre l'élément i et index_aleatoire
			temp <- l[i];
			l[i] <- l[index_aleatoire];
			l[index_aleatoire] <- temp;
		}
		
   		return l;
	} 
	
	// Mélange aléatoire d'une liste de paire
	list<pair<string, float>> melange_aleatoire_list_paire(list<pair<string, float>> l){
		
		int                 index_aleatoire;
		pair<string, float> temp;
		
		loop i from: length(l)-1 to: 1{
			// Génération d'un index aléatoire
			index_aleatoire <- rnd(0, i);
			
			// Echange entre l'élément i et index_aleatoire
			temp <- l[i];
			l[i] <- l[index_aleatoire];
			l[index_aleatoire] <- temp;
		}
		
   		return l;
	}
	
	// Retourne la liste entière des Accuse
	list<Accuse> get_all_instances(species<agent> spec) {
        return list<Accuse>(spec.population + spec.subspecies accumulate (get_all_instances(each)));
    }
    
    // Retourne la liste des identités de tous les agents mort
    list<int> liste_des_morts(int nb_total_accuse){
    	list<int> list_identite <- [];
		loop i from: 0 to: (nb_accuse_initial-1){
			bool est_vivant <- false;
			loop j from: 0 to: (nb_total_accuse-1){
				if list_accuse[j].identite = i{ 
					est_vivant <- true;
				}
			}
			if not est_vivant{ add i to: list_identite; }
		}
		
		return list_identite;
    }
}


/* 
 * DEFINITION DES STRATEGIES 
 */
species Accuse skills:[moving]{
	
	/*
	 * Classe mère de toutes les stratégies 
	 */
	
	// Affichage et positionnement 
	Commissariat emplacement;
	float 		 taille;
	rgb          couleur;
	
	// Attributs 
	float nb_annee_prison;
	int   nb_interrogatoire;
	int   nb_cooperation;
	int   nb_trahison; 
	
	// Stock le type de la classe fille
	string type;
	
	// Variables servant à la mémoire des Accusés
	list<int>  memoire_nb_trahison;
	list<int>  memoire_nb_match;
	list<bool> memoire_derniere_action;
	int        total_accuse;
	int        identite;
	
	/* Constructeur */
	init{
		emplacement <- one_of(Commissariat);
		location    <- emplacement.location;
		taille      <- 4.5;
		
		nb_annee_prison   <- 0.0;
		nb_interrogatoire <- 0;
		nb_cooperation    <- 0;
		nb_trahison       <- 0;
		
		memoire_nb_trahison     <- [];
		memoire_nb_match        <- [];
		memoire_derniere_action <- [];
		
		loop i from: 1 to: total_accuse{ 
			add 0 to: memoire_nb_trahison;
			add 0 to: memoire_nb_match;
			add flip(0.5) to: memoire_derniere_action; // On initialise aléatoirement la mémoire des dernières actions effectué par les adversaires
		}
	}	
	
	/* Aspect */
	aspect base {
		draw hexagon(taille) color: couleur;
	}
	
	/* Reflèxes */
	reflex se_deplacer{
		emplacement <- one_of(emplacement.neighbors);
		location    <- emplacement.location;
	}
	
	/* Gestion de la mort d'un agent */
	action enregistrement_deces virtual: true;
	
	// Un agent meurt s'il atteint le nombre d'année de prison max
	reflex mourir when: nb_annee_prison >= prison_max{
		do enregistrement_deces;
		do die;
	}
	
	/* Méthodes */
	
	// Met à jour la peine de prison d'un agent ainsi que les statistiques globales de sa stratégie
	// Méthode virtuelle devant être override par toutes les classes filles
	action enregistrer_condamnation(float condamnation) virtual: true;
	
	// Met à jour le nombre de match globale de l'espèce
	// Méthode virtuelle devant être override par toutes les classes filles
	action maj_nb_match_global virtual: true;
	
	// Met à jour le ratio globale de l'espèce
	// Méthode virtuelle devant être override par toutes les classes filles
	action maj_ratio_global virtual: true;
	
	// Met à jour les attributs d'un agent après un match
	action maj_attribut(bool trahison){
		nb_interrogatoire <- nb_interrogatoire + 1;
		if trahison{
			nb_trahison <- nb_trahison + 1;
		} else {
			nb_cooperation    <- nb_cooperation    + 1; 	
		}
	}
	
	// Retourne vrai si l'adversaire m'a déjà trahit
	bool a_deja_trahit(int identite_adversaire){ 
		return memoire_nb_trahison[identite_adversaire] > 0;
	}

	// Met à jour la mémoire d'un individu
	action memoire(int identite_adversaire, bool trahison){
		memoire_nb_match[identite_adversaire]        <- memoire_nb_match[identite_adversaire] + 1;
		memoire_derniere_action[identite_adversaire] <- trahison;
		if trahison{ 
			memoire_nb_trahison[identite_adversaire] <- memoire_nb_trahison[identite_adversaire] + 1;
		}
	}
	
	// Méthode virtuelle qui doit être override par toutes les classes filles. Cette méthode définit la stratégie de choix d'un agent
	// Elle retourne vrai si l'agent décide de trahir, faux s'il décide de coopérer
	bool trahir(int identite_adversaire) virtual: true;	
}

/* Espèces non dotées de mémoire */
species Traitre parent:Accuse {
	/*
	 * Stratégie : Trahit tout le temps 
	 * 
	 * Agent sans notion de mémoire
	 *
	*/
		
	/* Constructeur */
	init{
		couleur <- #red;
		type    <- 'Traitre';
	}	
		
	/* Méthodes */
	bool trahir(int identite_adversaire){		
		// L'agent fait son choix
		do maj_attribut(true);

		return true;
	}
	
	action maj_nb_match_global{	
		// Enregistrement du match dans une variable de global
		nb_match_traitre <- nb_match_traitre + 1;
	}
	
	action maj_ratio_global{
		// Mise à jour du ratio globale de l'espèce
		ratio_traitre <- annee_prison_traitre/nb_match_traitre;		
	}	
	
	action enregistrer_condamnation(float condamnation){
		nb_annee_prison		 <- nb_annee_prison + condamnation;
		annee_prison_traitre <- annee_prison_traitre + condamnation;
		prison_totale        <- prison_totale + condamnation;
	}
	
	action enregistrement_deces{
		nb_mort_traitre      <- nb_mort_traitre + 1;
		annee_prison_traitre <- annee_prison_traitre - nb_annee_prison;
		nb_match_traitre     <- nb_match_traitre - nb_interrogatoire;
	}
}

species Indecis parent:Accuse {
	/*
	 * Stratégie: Trahit avec une probabilité de 50%
	 * 
	 * Agent sans notion de mémoire
	 * 
	*/ 
	 
	
	/* Constructeur */
	init{
		couleur <- #green;
		type    <- 'Indecis';
	}	
			
	/* Méthodes */ 
	bool trahir(int identite_adversaire){
		
		// L'agent fait son choix
		bool trahison      <- flip(0.5);
		do maj_attribut(trahison);
		
		return trahison;
	}
	
	action maj_nb_match_global{	
		// Enregistrement du match dans une variable de global
		nb_match_indecis <- nb_match_indecis + 1;
	}
	
	action maj_ratio_global{
		// Mise à jour du ratio globale de l'espèce
		ratio_indecis <- annee_prison_indecis/nb_match_indecis;		
	}	
	
	action enregistrer_condamnation(float condamnation){
		nb_annee_prison		 <- nb_annee_prison + condamnation;
		annee_prison_indecis <- annee_prison_indecis + condamnation;
		prison_totale        <- prison_totale + condamnation;
	}
	
	action enregistrement_deces{
		nb_mort_indecis      <- nb_mort_indecis + 1;
		annee_prison_indecis <- annee_prison_indecis - nb_annee_prison;
		nb_match_indecis     <- nb_match_indecis - nb_interrogatoire;
	}
}

species Fidele parent:Accuse {
	/*
	 * Stratégie: Ne trahit jamais
	 *
	 * Agent sans notion de mémoire
	 * 
	*/
	
		
	/* Constructeur */
	init{
		couleur <- #blue;
		type    <- 'Fidele';
	}	
			
	/* Méthodes */
	bool trahir(int identite_adversaire){
		
		// L'agent fait son choix 
		do maj_attribut(false);

		return false;
	}
	
	action maj_nb_match_global{	
		// Enregistrement du match dans une variable de global
		nb_match_fidele <- nb_match_fidele + 1;
	}
	
	action maj_ratio_global{
		// Mise à jour du ratio globale de l'espèce
		ratio_fidele <- annee_prison_fidele/nb_match_fidele;		
	}	
	
	action enregistrer_condamnation(float condamnation){
		nb_annee_prison		 <- nb_annee_prison + condamnation;
		annee_prison_fidele  <- annee_prison_fidele + condamnation;
		prison_totale        <- prison_totale + condamnation;
	}
	
	action enregistrement_deces{
		nb_mort_fidele      <- nb_mort_fidele + 1;
		annee_prison_fidele <- annee_prison_fidele - nb_annee_prison;
		nb_match_fidele     <- nb_match_fidele - nb_interrogatoire;
	}
}

/* Espèce dotée de mémoire partielle */
species Girouette parent:Accuse {
	/*
	 * Stratégie : Inverse son choix à chaque fois indépendamment de l'adversaire
	 *
	 * Agent avec notion de mémoire (restreinte -> prise de décision ne dépend que de son propre dernier choix)
	*/
	// Attribut 
	bool dernier_choix;
	
	/* Constructeur */
	init{
		couleur <- #cyan;
		type    <- 'Girouette';
		
		if flip(0.5){
			dernier_choix <- true;
		}else{
			dernier_choix <- false;
		}
	}	
			
	/* Méthodes */ 
	bool trahir(int identite_adversaire){
		
		// L'agent fait son choix 
		dernier_choix <- !dernier_choix;
		do maj_attribut(dernier_choix);
		
		return dernier_choix;
	}
	
	action maj_nb_match_global{			
		// Enregistrement du match dans une variable de global
		nb_match_girouette <- nb_match_girouette + 1;
	}
	
	action maj_ratio_global{
		// Mise à jour du ratio globale de l'espèce
		ratio_girouette <- annee_prison_girouette/nb_match_girouette;		
	}	

	action enregistrer_condamnation(float condamnation){
		nb_annee_prison		   <- nb_annee_prison + condamnation;
		annee_prison_girouette <- annee_prison_girouette + condamnation;
		prison_totale          <- prison_totale + condamnation;
	}
	
	action enregistrement_deces{
		nb_mort_girouette      <- nb_mort_girouette + 1;
		annee_prison_girouette <- annee_prison_girouette - nb_annee_prison;
		nb_match_girouette     <- nb_match_girouette - nb_interrogatoire;
	}
}

/* Espèces dotées de mémoire */
species Revanchard parent:Accuse {
	/*
	 * Stratégie : Tant qu'on ne l'a pas trahit ne trahit pas. Dès qu'il a été trahit une fois par un agent spécifique -> 
	 *			   trahit avec une probabilité = nb_trahison_subit/nb_match
	 *
	 * Agent avec une notion de mémoire
 	*/
 	
	/* Constructeur */
	init{
		couleur <- #purple;
		type    <- 'Revanchard';
	}	
		
	/* Méthodes */ 
	bool trahir(int identite_adversaire){
		
		// L'agent fait son choix 
		int nb_trahison_adversaire <- memoire_nb_trahison[identite_adversaire];
		int nb_match_adversaire    <- memoire_nb_match[identite_adversaire];

		bool choix;
		if (nb_match_adversaire = 0){
			choix <- false;
		}else{
			choix <- flip(nb_trahison_adversaire/nb_match_adversaire);
		}
		
		do maj_attribut(choix);
		
		return choix;
	}
	
	action maj_nb_match_global{	
		// Enregistrement du match dans une variable de global
		nb_match_revanchard <- nb_match_revanchard + 1;
	}
	
	action maj_ratio_global{
		// Mise à jour du ratio globale de l'espèce
		ratio_revanchard <- annee_prison_revanchard/nb_match_revanchard;
	}	
		
	action enregistrer_condamnation(float condamnation){
		nb_annee_prison		    <- nb_annee_prison + condamnation;
		annee_prison_revanchard <- annee_prison_revanchard + condamnation;
		prison_totale        <- prison_totale + condamnation;
	}
	
	action enregistrement_deces{
		nb_mort_revanchard      <- nb_mort_revanchard + 1;
		annee_prison_revanchard <- annee_prison_revanchard - nb_annee_prison;
		nb_match_revanchard     <- nb_match_revanchard - nb_interrogatoire;
	}
}

species Rancunier parent:Accuse {
	/*
	 * Stratégie : Ne trahit pas ceux qui ne l'ont jamais trahit. Trahit les adversaires qui l'ont déjà trahit au moins une fois
	 *
	 * Agent avec notion de mémoire
	*/
	
	/* Constructeur */
	init{
		couleur <- #orange;
		type    <- 'Rancunier';
	}	
			
	/* Méthodes */ 
	bool trahir(int identite_adversaire){
				
		// L'agent fait son choix 
		bool trahison      <- a_deja_trahit(identite_adversaire);
		do maj_attribut(trahison);
		
		return trahison;
	}
	
	action maj_nb_match_global{			
		// Enregistrement du match dans une variable de global
		nb_match_rancunier <- nb_match_rancunier + 1;
	}
	
	action maj_ratio_global{
		// Mise à jour du ratio globale de l'espèce
		ratio_rancunier <- annee_prison_rancunier/nb_match_rancunier;		
	}	
	
	action enregistrer_condamnation(float condamnation){
		nb_annee_prison		   <- nb_annee_prison + condamnation;
		annee_prison_rancunier <- annee_prison_rancunier + condamnation;
		prison_totale          <- prison_totale + condamnation;
	}
	
	action enregistrement_deces{
		nb_mort_rancunier      <- nb_mort_rancunier + 1;
		annee_prison_rancunier <- annee_prison_rancunier - nb_annee_prison;
		nb_match_rancunier     <- nb_match_rancunier - nb_interrogatoire;
	}
}

species Imitateur parent:Accuse {
	/*
	 * Stratégie : Il imite le choix précedent de son adversaire actuelle. Si il l'a trahit au tour précédent alors il le trahit aussi
	 * 			   s'il ne l'avait pas trahit alors il ne le trahit pas. S'il tombe sur adversaire qu'il n'a jamais rencontré alors il 
	 *			   prend sa décision au hasard
	 *
	 * Agent avec notion de mémoire
	*/
	// Constructeur
	init{
		couleur <- #pink;
		type    <- 'Imitateur';
	}
	
	/* Méthodes */
	bool trahir(int identite_adversaire){
				
		// L'agent fait son choix 
		bool imitation <- memoire_derniere_action[identite_adversaire];
		do maj_attribut(imitation);
		
		return imitation;
	}
	
	action maj_nb_match_global{			
		// Enregistrement du match dans une variable de global
		nb_match_imitateur <- nb_match_imitateur + 1;
	}
	
	action maj_ratio_global{
		// Mise à jour du ratio globale de l'espèce
		ratio_imitateur <- annee_prison_imitateur/nb_match_imitateur;		
	}	
	
	action enregistrer_condamnation(float condamnation){
		nb_annee_prison		   <- nb_annee_prison + condamnation;
		annee_prison_imitateur <- annee_prison_imitateur + condamnation;
		prison_totale          <- prison_totale + condamnation;
	}
	
	action enregistrement_deces{
		nb_mort_imitateur      <- nb_mort_imitateur + 1;
		annee_prison_imitateur <- annee_prison_imitateur - nb_annee_prison;
		nb_match_imitateur     <- nb_match_imitateur - nb_interrogatoire;
	}
}

/* Environnement */
grid Commissariat width: 25 height: 25 neighbors: 6{
	
	// Variable contenant les accusés présent dans la cellule
	list<Accuse> accuses;
	
	init{
		color <- rgb(255, 255, 255); 		 // Couleur d'une cellule  
		neighbors  <- (self neighbors_at 2); // Liste des cellules voisines voisins
	}
	
	// Récupère la liste des accusés présent dans la cellule au cycle actuel
	reflex recupererAccuse{
		accuses <- list<Accuse>(agents_inside(self));
	}
	
	// S'exècute lorsqu'exactement deux agents sont dans la même case
	reflex interrogatoire when: length(accuses)=2{
		
		// Récupération des accusés
		Accuse accuse_un   <- accuses[0];
		Accuse accuse_deux <- accuses[1];
		
		// Récupération des identités des deux accusés
		int  identite_un   <- accuse_un.identite;
		int  identite_deux <- accuse_deux.identite;
	
		// Demande à chaque accusé son choix (trahir ou non)
		bool choix_accuse_un   <- false;
		bool choix_accuse_deux <- false;
		ask accuse_un {
			choix_accuse_un   <- self.trahir(identite_deux);
		}
		ask accuse_deux {
			choix_accuse_deux <- self.trahir(identite_un);
		}
		
		// Analyse des résultats
		float condamnation_accuse_un;
		float condamnation_accuse_deux;
		
		if not choix_accuse_un and not choix_accuse_deux{
			// Personne ne trahit	
			condamnation_accuse_un   <- 0.5;
			condamnation_accuse_deux <- 0.5;
		}
		else if not choix_accuse_un and choix_accuse_deux{
			// L'adversaire 1 trahit l'adversaire 0
			condamnation_accuse_un   <- 10.0;
			condamnation_accuse_deux <- 0.0;
		}
		else if choix_accuse_un and not choix_accuse_deux{
			// L'adversaire 0 trahit l'adversaire 1
			condamnation_accuse_un   <- 0.0;
			condamnation_accuse_deux <- 10.0;
		}
		else{
			// Les deux trahissent 
			condamnation_accuse_un   <- 5.0;
			condamnation_accuse_deux <- 5.0;
		}
		
		// Communique aux deux agents leur comdamnation ainsi que le choix de leur adversaire
		ask accuse_un {
			do enregistrer_condamnation(condamnation_accuse_un); // Ajoute les années de prison
			do maj_nb_match_global;								 // Incrémente le nombre de match de l'espèce
			do maj_ratio_global;								 // Met à jour le ratio globale de l'espèce
			do memoire(identite_deux, choix_accuse_deux);        // Met à jour la mémoire
			
			// Dispatch les deux protagonistes pour diminuer les effets de bords
			if dispersion{
				self.emplacement <- one_of(Commissariat);								
				self.location    <- self.emplacement.location;	
			}
		}
		ask accuse_deux {
			do enregistrer_condamnation(condamnation_accuse_deux); // Ajoute les années de prison
			do maj_nb_match_global;								   // Incrémente le nombre de match de l'espèce
			do maj_ratio_global;								   // Met à jour le ratio globale de l'espèce
			do memoire(identite_un, choix_accuse_un);			   // Met à jour la mémoire
			
			// Dispatch les deux protagonistes pour diminuer les effets de bords
			if dispersion{
				self.emplacement <- one_of(Commissariat);								
				self.location    <- self.emplacement.location;	
			}
		}
		
		// Mise à jour variable globale 
		nb_match <- nb_match + 1;
		condamnation_moyenne <- prison_totale/nb_match;	
	}
}

/* Expérimentation */
experiment DilemmePrisonnier type: gui{
	/* Paramètre initiaux */ 
	// Catégorie espèce
	parameter "Traitres initiaux: "   var: nb_traitre    min: 0 max: 25 category: "Accusé";
	parameter "Fidèle initiaux: "     var: nb_fidele     min: 0 max: 25 category: "Accusé";
	parameter "Indecis initiaux: "    var: nb_indecis    min: 0 max: 25 category: "Accusé";
	parameter "Revanchard initiaux: " var: nb_revanchard min: 0 max: 25 category: "Accusé";
	parameter "Rancunier initiaux: "  var: nb_rancunier  min: 0 max: 25 category: "Accusé";
	parameter "Girouette initiaux: "  var: nb_girouette  min: 0 max: 25 category: "Accusé";
	parameter "Imitateur initiaux: "  var: nb_imitateur  min: 0 max: 25 category: "Accusé";
	
	// Mode de reproduction
	parameter "Reproduction par meilleure agent"                     var: reproduction_un     category: "Reproduction";
	parameter "Reproduction random parmis les 10% meilleurs agents " var: reproduction_deux   category: "Reproduction";
	parameter "Reproduction de l'agent ayant le meilleur ratio"      var: reproduction_trois  category: "Reproduction";
	parameter "Reproduction de la classe ayant le meilleur ratio"    var: reproduction_quatre category: "Reproduction";
	
	// Catégorie prison
	parameter "Année de prison maximum"  var: prison_max min: 10 max: 200 category: "Prison";
	
	// Catégorie dispersion
	parameter "Activer la dispersion aléatoire après chaque match ?"  var: dispersion category: "Dispersion";
	
	// Affichage de la grille
	output {
		display DilemmeDuPrisonnier {
			// Grid
			grid Commissariat border: rgb(240, 240, 240);
			
			// Espèces 
			species Traitre 	aspect: base;
			species Fidele   	aspect: base;
			species Indecis     aspect: base;
			species Revanchard  aspect: base;
			species Rancunier 	aspect: base;
			species Girouette 	aspect: base;
			species Imitateur 	aspect: base;
		}
		
		monitor "Traitre"    value: nb_traitre;
		monitor "Fidele"     value: nb_fidele;
		monitor "Indecis"    value: nb_indecis;
		monitor "Revanchard" value: nb_revanchard;
		monitor "Rancunier"  value: nb_rancunier;
		monitor "Girouette"  value: nb_girouette;
		monitor "Imitateur"  value: nb_imitateur;
		
		display Strategies refresh:every(5#cycles) {
			chart "Stratégies Evolution" type: series size: {1,1} position: {0, 0}{
				data "Traitre"    value: nb_traitre    color: #red;
				data "Fidele"     value: nb_fidele     color: #blue;				
				data "Indecis"    value: nb_indecis    color: #green;
				data "Revanchard" value: nb_revanchard color: #purple;				
				data "Rancunier"  value: nb_rancunier  color: #orange;				
				data "Girouette"  value: nb_girouette  color: #cyan;
				data "Imitateur"  value: nb_imitateur  color: #pink;								
			}
		}
		display Prison refresh: every(5#cycles){
			chart "Condamnation moyenne Evolution" type: series size: {1, 1} position: {0, 0}{
				data "Condamnation moyenne" value: condamnation_moyenne color: #red;
			}
		}
		display Ratio refresh: every(5#cycles){
			chart "Moyenne : Année de prison / Nombre d'interrogatoire" type: series size: {1, 1} position: {0, 0}{
				data "Traitre"    value: ratio_traitre    color: #red;
				data "Fidele"     value: ratio_fidele     color: #blue;				
				data "Indecis"    value: ratio_indecis    color: #green;
				data "Revanchard" value: ratio_revanchard color: #purple;				
				data "Rancunier"  value: ratio_rancunier  color: #orange;				
				data "Girouette"  value: ratio_girouette  color: #cyan;
				data "Imitateur"  value: ratio_imitateur  color: #pink;				
			}
		}
	}	
}
