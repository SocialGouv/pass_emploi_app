import 'package:equatable/equatable.dart';

class Metier extends Equatable {
  static List<Metier> values = [
    Metier._("G1404", "Management d'établissement de restauration collective"),
    Metier._("G1501", "Personnel d'étage"),
    Metier._("G1502", "Personnel polyvalent d'hôtellerie"),
    Metier._("G1503", "Management du personnel d'étage"),
    Metier._("F1101", "Architecture du BTP et du paysage"),
    Metier._("F1102", "Conception - aménagement d'espaces intérieurs"),
    Metier._("F1104", "Dessin BTP et paysage"),
    Metier._("F1201", "Conduite de travaux du BTP et de travaux paysagers"),
    Metier._("F1106", "Ingénierie et études du BTP"),
    Metier._("F1204", "Qualité Sécurité Environnement et protection santé du BTP"),
    Metier._("F1301", "Conduite de grue"),
    Metier._("F1302", "Conduite d'engins de terrassement et de carrière"),
    Metier._("F1402", "Extraction solide"),
    Metier._("F1602", "Électricité bâtiment"),
    Metier._("F1502", "Montage de structures métalliques"),
    Metier._("F1401", "Extraction liquide et gazeuse"),
    Metier._("F1605", "Montage de réseaux électriques et télécoms"),
    Metier._("F1611", "Réalisation et restauration de façades"),
    Metier._("F1613", "Travaux d'étanchéité et d'isolation"),
    Metier._("F1702", "Construction de routes et voies"),
    Metier._("F1612", "Taille et décoration de pierres"),
    Metier._("F1607", "Pose de fermetures menuisées"),
    Metier._("F1610", "Pose et restauration de couvertures"),
    Metier._("G1605", "Plonge en restauration"),
    Metier._("G1403", "Gestion de structure de loisirs ou d'hébergement touristique"),
    Metier._("G1102", "Promotion du tourisme local"),
    Metier._("G1303", "Vente de voyages"),
    Metier._("F1103", "Contrôle et diagnostic technique du bâtiment"),
    Metier._("F1203", "Direction et ingénierie d'exploitation de gisements et de carrières"),
    Metier._("F1107", "Mesures topographiques"),
    Metier._("F1108", "Métré de la construction"),
    Metier._("F1105", "Études géologiques"),
    Metier._("F1202", "Direction de chantier du BTP"),
    Metier._("F1503", "Réalisation - installation d'ossatures bois"),
    Metier._("F1501", "Montage de structures et de charpentes bois"),
    Metier._("D1403", "Relation commerciale auprès de particuliers"),
    Metier._("F1601", "Application et décoration en plâtre, stuc et staff"),
    Metier._("F1703", "Maçonnerie"),
    Metier._("G1201", "Accompagnement de voyages, d'activités culturelles ou sportives"),
    Metier._("F1706", "Préfabrication en béton industriel"),
    Metier._("F1704", "Préparation du gros oeuvre et des travaux publics"),
    Metier._("F1705", "Pose de canalisations"),
    Metier._("F1606", "Peinture en bâtiment"),
    Metier._("F1604", "Montage d'agencements"),
    Metier._("F1603", "Installation d'équipements sanitaires et thermiques"),
    Metier._("G1202", "Animation d'activités culturelles ou ludiques"),
    Metier._("F1701", "Construction en béton"),
    Metier._("G1402", "Management d'hôtel-restaurant"),
    Metier._("G1302", "Optimisation de produits touristiques"),
    Metier._("G1401", "Assistance de direction d'hôtel-restaurant"),
    Metier._("F1609", "Pose de revêtements souples"),
    Metier._("G1206", "Personnel technique des jeux"),
    Metier._("F1608", "Pose de revêtements rigides"),
    Metier._("G1204", "Éducation en activités sportives"),
    Metier._("G1101", "Accueil touristique"),
    Metier._("G1203", "Animation de loisirs auprès d'enfants ou d'adolescents"),
    Metier._("G1702", "Personnel du hall"),
    Metier._("H1205", "Études - modèles en industrie des matériaux souples"),
    Metier._("H1102", "Management et ingénierie d'affaires"),
    Metier._("H1203", "Conception et dessin produits mécaniques"),
    Metier._("H1206", "Management et ingénierie études, recherche et développement industriel"),
    Metier._("H1204", "Design industriel"),
    Metier._("H1209", "Intervention technique en études et développement électronique"),
    Metier._("H2206", "Réalisation de menuiserie bois et tonnellerie"),
    Metier._("H2401", "Assemblage - montage d'articles en cuirs, peaux"),
    Metier._("H2301", "Conduite d'équipement de production chimique ou pharmaceutique"),
    Metier._("H2403", "Conduite de machine de fabrication de produits textiles"),
    Metier._("H2405", "Conduite de machine de textiles nontissés"),
    Metier._("H2406", "Conduite de machine de traitement textile"),
    Metier._("H2409", "Coupe cuir, textile et matériaux souples"),
    Metier._("H2208", "Réalisation d'ouvrages décoratifs en bois"),
    Metier._("H2407", "Conduite de machine de transformation et de finition des cuirs et peaux"),
    Metier._("H2505", "Encadrement d'équipe ou d'atelier en matériaux souples"),
    Metier._("H2415", "Contrôle en industrie du cuir et du textile"),
    Metier._("H2501", "Encadrement de production de matériel électrique et électronique"),
    Metier._("H2604", "Montage de produits électriques et électroniques"),
    Metier._("H2413", "Préparation de fils, montage de métiers textiles"),
    Metier._("H2701", "Pilotage d'installation énergétique et pétrochimique"),
    Metier._("H2411", "Montage de prototype cuir et matériaux souples"),
    Metier._("H2503", "Pilotage d'unité élémentaire de production mécanique ou de travail des métaux"),
    Metier._("H2602", "Câblage électrique et électromécanique"),
    Metier._("H2209", "Intervention technique en ameublement et bois"),
    Metier._("H2203", "Conduite d'installation de production de panneaux bois"),
    Metier._("H2101", "Abattage et découpe des viandes"),
    Metier._("H2205", "Première transformation de bois d'oeuvre"),
    Metier._("H2201", "Assemblage d'ouvrages en bois"),
    Metier._("H1505", "Intervention technique en formulation et analyse sensorielle"),
    Metier._("H2207", "Réalisation de meubles en bois"),
    Metier._("H2402", "Assemblage - montage de vêtements et produits textiles"),
    Metier._("H2404", "Conduite de machine de production et transformation des fils"),
    Metier._("H2410", "Mise en forme, repassage et finitions en industrie textile"),
    Metier._("H2408", "Conduite de machine d'impression textile"),
    Metier._("H2412", "Patronnage - gradation"),
    Metier._("H2801", "Conduite d'équipement de transformation du verre"),
    Metier._("H2601", "Bobinage électrique"),
    Metier._("G1804", "Sommellerie"),
    Metier._("G1802", "Management du service en restauration"),
    Metier._("H1202", "Conception et dessin de produits électriques et électroniques"),
    Metier._("H1208", "Intervention technique en études et conception en automatisme"),
    Metier._("H1210", "Intervention technique en études, recherche et développement"),
    Metier._("H1207", "Rédaction technique"),
    Metier._("H1302", "Management et ingénierie Hygiène Sécurité Environnement -HSE- industriels"),
    Metier._("H1403", "Intervention technique en gestion industrielle et logistique"),
    Metier._("H1401", "Management et ingénierie gestion industrielle et logistique"),
    Metier._("H1503", "Intervention technique en laboratoire d'analyse industrielle"),
    Metier._("H1501", "Direction de laboratoire d'analyse industrielle"),
    Metier._("G1801", "Café, bar brasserie"),
    Metier._("G1701", "Conciergerie en hôtellerie"),
    Metier._("G1803", "Service en restauration"),
    Metier._("G1703", "Réception en hôtellerie"),
    Metier._("H1101", "Assistance et support technique client"),
    Metier._("G1604", "Fabrication de crêpes ou pizzas"),
    Metier._("G1601", "Management du personnel de cuisine"),
    Metier._("H1303", "Intervention technique en Hygiène Sécurité Environnement -HSE- industriel"),
    Metier._("H1504", "Intervention technique en contrôle essai qualité en électricité et électronique"),
    Metier._("H2102", "Conduite d'équipement de production alimentaire"),
    Metier._("H2204", "Encadrement des industries de l'ameublement et du bois"),
    Metier._("H2202", "Conduite d'équipement de fabrication de l'ameublement et du bois"),
    Metier._("H1404", "Intervention technique en méthodes et industrialisation"),
    Metier._("H1402", "Management et ingénierie méthodes et industrialisation"),
    Metier._("H1506", "Intervention technique qualité en mécanique et travail des métaux"),
    Metier._("H1301", "Inspection de conformité"),
    Metier._("H1201", "Expertise technique couleur en industrie"),
    Metier._("H1502", "Management et ingénierie qualité industrielle"),
    Metier._("G1205", "Personnel d'attractions ou de structures de loisirs"),
    Metier._("G1602", "Personnel de cuisine"),
    Metier._("G1603", "Personnel polyvalent en restauration"),
    Metier._("G1301", "Conception de produits touristiques"),
    Metier._("H2502", "Management et ingénierie de production"),
    Metier._("H2802", "Conduite d'installation de production de matériaux de construction"),
    Metier._("H2803", "Façonnage et émaillage en industrie céramique"),
    Metier._("H2804", "Pilotage de centrale à béton prêt à l'emploi, ciment, enrobés et granulats"),
    Metier._("H2902", "Chaudronnerie - tôlerie"),
    Metier._("I1304", "Installation et maintenance d'équipements industriels et d'exploitation"),
    Metier._("J1301", "Personnel polyvalent des services hospitaliers"),
    Metier._("J1303", "Assistance médico-technique"),
    Metier._("J1305", "Conduite de véhicules sanitaires"),
    Metier._("J1201", "Biologie médicale"),
    Metier._("J1302", "Analyses médicales"),
    Metier._("J1307", "Préparation en pharmacie"),
    Metier._("H2913", "Soudage manuel"),
    Metier._("H2805", "Pilotage d'installation de production verrière"),
    Metier._("H2910", "Moulage sable"),
    Metier._("H2904", "Conduite d'équipement de déformation des métaux"),
    Metier._("H2908", "Modelage de matériaux non métalliques"),
    Metier._("H2912", "Réglage d'équipement de production industrielle"),
    Metier._("H2906", "Conduite d'installation automatisée ou robotisée de fabrication mécanique"),
    Metier._("H3203", "Fabrication de pièces en matériaux composites"),
    Metier._("H3201", "Conduite d'équipement de formage des plastiques et caoutchoucs"),
    Metier._("H3302", "Opérations manuelles d'assemblage, tri ou emballage"),
    Metier._("H3101", "Conduite d'équipement de fabrication de papier ou de carton"),
    Metier._("H3401", "Conduite de traitement d'abrasion de surface"),
    Metier._("H3402", "Conduite de traitement par dépôt de surface"),
    Metier._("I1101", "Direction et ingénierie en entretien infrastructure et bâti"),
    Metier._("H3403", "Conduite de traitement thermique"),
    Metier._("I1201", "Entretien d'affichage et mobilier urbain"),
    Metier._("I1102", "Management et ingénierie de maintenance industrielle"),
    Metier._("I1203", "Maintenance des bâtiments et des locaux"),
    Metier._("I1306", "Installation et maintenance en froid, conditionnement d'air"),
    Metier._("J1103", "Médecine dentaire"),
    Metier._("I1310", "Maintenance mécanique industrielle"),
    Metier._("I1501", "Intervention en grande hauteur"),
    Metier._("I1308", "Maintenance d'installation de chauffage"),
    Metier._("I1603", "Maintenance d'engins de chantier, levage, manutention et de machines agricoles"),
    Metier._("I1402", "Réparation de biens électrodomestiques et multimédia"),
    Metier._("I1503", "Intervention en milieux et produits nocifs"),
    Metier._("I1602", "Maintenance d'aéronefs"),
    Metier._("I1303", "Installation et maintenance de distributeurs automatiques"),
    Metier._("I1605", "Mécanique de marine"),
    Metier._("I1607", "Réparation de cycles, motocycles et motoculteurs de loisirs"),
    Metier._(
        "H2603", "Conduite d'installation automatisée de production électrique, électronique et microélectronique"),
    Metier._("H2605", "Montage et câblage électronique"),
    Metier._("H2414", "Préparation et finition d'articles en cuir et matériaux souples"),
    Metier._("H2504", "Encadrement d'équipe en industrie de transformation"),
    Metier._("N2201", "Personnel d'escale aéroportuaire"),
    Metier._("N2202", "Contrôle de la navigation aérienne"),
    Metier._("N2102", "Pilotage et navigation technique aérienne"),
    Metier._("N3103", "Navigation fluviale"),
    Metier._("N3101", "Encadrement de la navigation maritime"),
    Metier._("N4201", "Direction d'exploitation des transports routiers de marchandises"),
    Metier._("N3203", "Manutention portuaire"),
    Metier._("N4203", "Intervention technique d'exploitation des transports routiers de marchandises"),
    Metier._("N4403", "Manoeuvre du réseau ferré"),
    Metier._("I1301", "Installation et maintenance d'ascenseurs"),
    Metier._("I1305", "Installation et maintenance électronique"),
    Metier._("I1601", "Installation et maintenance en nautisme"),
    Metier._("I1401", "Maintenance informatique et bureautique"),
    Metier._("I1502", "Intervention en milieu subaquatique"),
    Metier._("I1307", "Installation et maintenance télécoms et courants faibles"),
    Metier._("I1309", "Maintenance électrique"),
    Metier._("J1101", "Médecine de prévention"),
    Metier._("I1604", "Mécanique automobile et entretien de véhicules"),
    Metier._("I1606", "Réparation de carrosserie"),
    Metier._("J1202", "Pharmacie"),
    Metier._("J1304", "Aide en puériculture"),
    Metier._("J1102", "Médecine généraliste et spécialisée"),
    Metier._("J1104", "Suivi de la grossesse et de l'accouchement"),
    Metier._("M1402", "Conseil en organisation et management d'entreprise"),
    Metier._("M1404", "Management et gestion d'enquêtes"),
    Metier._("M1502", "Développement des ressources humaines"),
    Metier._("M1601", "Accueil et renseignements"),
    Metier._("M1608", "Secrétariat comptable"),
    Metier._("M1704", "Management relation clientèle"),
    Metier._("M1701", "Administration des ventes"),
    Metier._("M1606", "Saisie de données"),
    Metier._("M1706", "Promotion des ventes"),
    Metier._("M1803", "Direction des systèmes d'information"),
    Metier._("M1805", "Études et développement informatique"),
    Metier._("M1801", "Administration de systèmes d'information"),
    Metier._("M1808", "Information géographique"),
    Metier._("N1201", "Affrètement transport"),
    Metier._("N4401", "Circulation du réseau ferré"),
    Metier._("N4301", "Conduite sur rails"),
    Metier._("H2901", "Ajustement et montage de fabrication"),
    Metier._("H2903", "Conduite d'équipement d'usinage"),
    Metier._("H2909", "Montage-assemblage mécanique"),
    Metier._("H3102", "Conduite d'installation de pâte à papier"),
    Metier._("H2907", "Conduite d'installation de production des métaux"),
    Metier._("H2905", "Conduite d'équipement de formage et découpage des matériaux"),
    Metier._("H2911", "Réalisation de structures métalliques"),
    Metier._("H2914", "Réalisation et montage en tuyauterie"),
    Metier._("H3301", "Conduite d'équipement de conditionnement"),
    Metier._("H3303", "Préparation de matières et produits industriels (broyage, mélange, ...)"),
    Metier._("H3202", "Réglage d'équipement de formage des plastiques et caoutchoucs"),
    Metier._("H3404", "Peinture industrielle"),
    Metier._("I1202", "Entretien et surveillance du tracé routier"),
    Metier._("I1103", "Supervision d'entretien et gestion de véhicules"),
    Metier._("I1302", "Installation et maintenance d'automatismes"),
    Metier._("N2204", "Préparation des vols"),
    Metier._("N3201", "Exploitation des opérations portuaires et du transport maritime"),
    Metier._("N4102", "Conduite de transport de particuliers"),
    Metier._("N4104", "Courses et livraisons express"),
    Metier._("N4101", "Conduite de transport de marchandises sur longue distance"),
    Metier._("N2205", "Direction d'escale et exploitation aéroportuaire"),
    Metier._("N3202", "Exploitation du transport fluvial"),
    Metier._("N3102", "Équipage de la navigation maritime"),
    Metier._("J1405", "Optique - lunetterie"),
    Metier._("J1403", "Ergothérapie"),
    Metier._("J1411", "Prothèses et orthèses"),
    Metier._("J1409", "Pédicurie et podologie"),
    Metier._("J1407", "Orthoptique"),
    Metier._("K1206", "Intervention socioculturelle"),
    Metier._("K1101", "Accompagnement et médiation familiale"),
    Metier._("K1201", "Action sociale"),
    Metier._("K1103", "Développement personnel et bien-être de la personne"),
    Metier._("J1501", "Soins d'hygiène, de confort du patient"),
    Metier._("K1204", "Médiation sociale et facilitation de la vie en société"),
    Metier._("J1506", "Soins infirmiers généralistes"),
    Metier._("J1504", "Soins infirmiers spécialisés en bloc opératoire"),
    Metier._("K1202", "Éducation de jeunes enfants"),
    Metier._("J1502", "Coordination de services médicaux ou paramédicaux"),
    Metier._("N4103", "Conduite de transport en commun sur route"),
    Metier._("N4105", "Conduite et livraison par tournées sur courte distance"),
    Metier._("N4302", "Contrôle des transports en commun"),
    Metier._("N4204", "Intervention technique d'exploitation des transports routiers de personnes"),
    Metier._("N4202", "Direction d'exploitation des transports routiers de personnes"),
    Metier._("N4402", "Exploitation et manoeuvre des remontées mécaniques"),
    Metier._("M1810", "Production et exploitation de systèmes d'information"),
    Metier._("N1103", "Magasinage et préparation de commandes"),
    Metier._("N2203", "Exploitation des pistes aéroportuaires"),
    Metier._("K1401", "Conception et pilotage de la politique des pouvoirs publics"),
    Metier._("K1502", "Contrôle et inspection des Affaires Sociales"),
    Metier._("K1701", "Personnel de la Défense"),
    Metier._("K1601", "Gestion de l'information et de la documentation"),
    Metier._("L1508", "Prise de son et sonorisation"),
    Metier._("M1206", "Management de groupe ou de service comptable"),
    Metier._("M1102", "Direction des achats"),
    Metier._("M1201", "Analyse et ingénierie financière"),
    Metier._("M1301", "Direction de grande entreprise ou d'établissement public"),
    Metier._("J1306", "Imagerie médicale"),
    Metier._("J1401", "Audioprothèses"),
    Metier._("K1102", "Aide aux bénéficiaires d'une mesure de protection juridique"),
    Metier._("J1507", "Soins infirmiers spécialisés en puériculture"),
    Metier._("J1408", "Ostéopathie et chiropraxie"),
    Metier._("J1404", "Kinésithérapie"),
    Metier._("J1402", "Diététique"),
    Metier._("J1505", "Soins infirmiers spécialisés en prévention"),
    Metier._("J1503", "Soins infirmiers spécialisés en anesthésie"),
    Metier._("J1412", "Rééducation en psychomotricité"),
    Metier._("K1305", "Intervention sociale et familiale"),
    Metier._("J1406", "Orthophonie"),
    Metier._("J1410", "Prothèses dentaires"),
    Metier._("K1203", "Encadrement technique en insertion professionnelle"),
    Metier._("K1205", "Information sociale"),
    Metier._("K1104", "Psychologie"),
    Metier._("K1402", "Conseil en Santé Publique"),
    Metier._("K1303", "Assistance auprès d'enfants"),
    Metier._("K1302", "Assistance auprès d'adultes"),
    Metier._("K1207", "Intervention socioéducative"),
    Metier._("K1505", "Protection des consommateurs et contrôle des échanges commerciaux"),
    Metier._("K1602", "Gestion de patrimoine culturel"),
    Metier._("K1504", "Contrôle et inspection du Trésor Public"),
    Metier._("K1503", "Contrôle et inspection des impôts"),
    Metier._("K1404", "Mise en oeuvre et pilotage de la politique des pouvoirs publics"),
    Metier._("K1501", "Application des règles financières publiques"),
    Metier._("K1704", "Management de la sécurité publique"),
    Metier._("K1801", "Conseil en emploi et insertion socioprofessionnelle"),
    Metier._("K1706", "Sécurité publique"),
    Metier._("K1703", "Direction opérationnelle de la défense"),
    Metier._("K1902", "Collaboration juridique"),
    Metier._("K1904", "Magistrature"),
    Metier._("K2104", "Éducation et surveillance au sein d'établissements d'enseignement"),
    Metier._("K2107", "Enseignement général du second degré"),
    Metier._("K2109", "Enseignement technique et professionnel"),
    Metier._("K2112", "Orientation scolaire et professionnelle"),
    Metier._("K2303", "Nettoyage des espaces urbains"),
    Metier._("K2601", "Conduite d'opérations funéraires"),
    Metier._("K2306", "Supervision d'exploitation éco-industrielle"),
    Metier._("K2301", "Distribution et assainissement d'eau"),
    Metier._("K2402", "Recherche en sciences de l'univers, de la matière et du vivant"),
    Metier._("K2502", "Management de sécurité privée"),
    Metier._("L1204", "Arts du cirque et arts visuels"),
    Metier._("L1302", "Production et administration spectacle, cinéma et audiovisuel"),
    Metier._("L1303", "Promotion d'artistes et de spectacles"),
    Metier._("L1103", "Présentation de spectacles ou d'émissions"),
    Metier._("L1304", "Réalisation cinématographique et audiovisuelle"),
    Metier._("L1401", "Sportif professionnel"),
    Metier._("L1501", "Coiffure et maquillage spectacle"),
    Metier._("L1202", "Musique et chant"),
    Metier._("L1502", "Costume et habillage spectacle"),
    Metier._("L1503", "Décor et accessoires spectacle"),
    Metier._("L1504", "Éclairage spectacle"),
    Metier._("L1505", "Image cinématographique et télévisuelle"),
    Metier._("L1506", "Machinerie spectacle"),
    Metier._("M1203", "Comptabilité"),
    Metier._("K1301", "Accompagnement médicosocial"),
    Metier._("K1304", "Services domestiques"),
    Metier._("K1403", "Management de structure de santé, sociale ou pénitentiaire"),
    Metier._("K1405", "Représentation de l'État sur le territoire national ou international"),
    Metier._("K2103", "Direction d'établissement et d'enseignement"),
    Metier._("K1707", "Surveillance municipale"),
    Metier._("K2102", "Coordination pédagogique"),
    Metier._("K1903", "Défense et conseil juridique"),
    Metier._("K2101", "Conseil en formation"),
    Metier._("M1205", "Direction administrative et financière"),
    Metier._("M1403", "Études et prospectives socio-économiques"),
    Metier._("M1302", "Direction de petite ou moyenne entreprise"),
    Metier._("M1501", "Assistanat en ressources humaines"),
    Metier._("M1207", "Trésorerie et financement"),
    Metier._("M1401", "Conduite d'enquêtes"),
    Metier._("M1703", "Management et gestion de produit"),
    Metier._("M1604", "Assistanat de direction"),
    Metier._("M1603", "Distribution de documents"),
    Metier._("M1602", "Opérations administratives"),
    Metier._("M1503", "Management des ressources humaines"),
    Metier._("M1707", "Stratégie commerciale"),
    Metier._("M1802", "Expertise et support en systèmes d'information"),
    Metier._("M1605", "Assistanat technique et administratif"),
    Metier._("M1804", "Études et développement de réseaux de télécoms"),
    Metier._("M1609", "Secrétariat et assistanat médical ou médico-social"),
    Metier._("M1705", "Marketing"),
    Metier._("M1607", "Secrétariat"),
    Metier._("M1702", "Analyse de tendance"),
    Metier._("M1807", "Exploitation de systèmes de communication et de commandement"),
    Metier._("M1806", "Conseil et maîtrise d'ouvrage en systèmes d'information"),
    Metier._("N1101", "Conduite d'engins de déplacement des charges"),
    Metier._("N1102", "Déménagement"),
    Metier._("M1809", "Information météorologique"),
    Metier._("N1104", "Manoeuvre et conduite d'engins lourds de manutention"),
    Metier._("N1105", "Manutention manuelle de charges"),
    Metier._("N1202", "Gestion des opérations de circulation internationale des marchandises"),
    Metier._("K2105", "Enseignement artistique"),
    Metier._("K2106", "Enseignement des écoles"),
    Metier._("K2110", "Formation en conduite de véhicules"),
    Metier._("K2111", "Formation professionnelle"),
    Metier._("K2603", "Thanatopraxie"),
    Metier._("K2401", "Recherche en sciences de l'homme et de la société"),
    Metier._("K2304", "Revalorisation de produits industriels"),
    Metier._("K2501", "Gardiennage de locaux"),
    Metier._("K2602", "Conseil en services funéraires"),
    Metier._("K2503", "Sécurité et surveillance privées"),
    Metier._("K2302", "Management et inspection en environnement urbain"),
    Metier._("K2202", "Lavage de vitres"),
    Metier._("K2201", "Blanchisserie industrielle"),
    Metier._("K2108", "Enseignement supérieur"),
    Metier._("K2305", "Salubrité et traitement de nuisibles"),
    Metier._("K2203", "Management et inspection en propreté de locaux"),
    Metier._("K2204", "Nettoyage de locaux"),
    Metier._("L1102", "Mannequinat et pose artistique"),
    Metier._("L1203", "Art dramatique"),
    Metier._("L1101", "Animation musicale et scénique"),
    Metier._("L1201", "Danse"),
    Metier._("L1301", "Mise en scène de spectacles vivants"),
    Metier._("M1204", "Contrôle de gestion"),
    Metier._("M1101", "Achats"),
    Metier._("L1509", "Régie générale"),
    Metier._("L1507", "Montage audiovisuel et post-production"),
    Metier._("M1202", "Audit et contrôle comptables et financiers"),
    Metier._("K1702", "Direction de la sécurité civile et des secours"),
    Metier._("K1901", "Aide et médiation judiciaire"),
    Metier._("K1802", "Développement local"),
    Metier._("K1705", "Sécurité civile et secours"),
    Metier._("A1502", "Podologie animale"),
    Metier._("B1302", "Décoration d'objets d'art et artisanaux"),
    Metier._("B1401", "Réalisation d'objets en lianes, fibres et brins végétaux"),
    Metier._("A1416", "Polyculture, élevage"),
    Metier._("B1802", "Réalisation d'articles en cuir et matériaux souples (hors vêtement)"),
    Metier._("C1106", "Expertise risques en assurances"),
    Metier._("B1101", "Création en arts plastiques"),
    Metier._("B1301", "Décoration d'espaces de vente et d'exposition"),
    Metier._("B1402", "Reliure et restauration de livres et archives"),
    Metier._("B1804", "Réalisation d'ouvrages d'art en fils"),
    Metier._("A1504", "Santé animale"),
    Metier._("B1806", "Tapisserie - décoration en ameublement"),
    Metier._("C1205", "Conseil en gestion de patrimoine financier"),
    Metier._("C1302", "Gestion back et middle-office marchés financiers"),
    Metier._("B1501", "Fabrication et réparation d'instruments de musique"),
    Metier._("B1604", "Réparation - montage en systèmes horlogers"),
    Metier._("B1801", "Réalisation d'articles de chapellerie"),
    Metier._("B1803", "Réalisation de vêtements sur mesure ou en petite série"),
    Metier._("C1101", "Conception - développement produits d'assurances"),
    Metier._("C1110", "Souscription d'assurances"),
    Metier._("C1201", "Accueil et services bancaires"),
    Metier._("C1204", "Conception et expertise produits bancaires et financiers"),
    Metier._("B1601", "Métallerie d'art"),
    Metier._("B1603", "Réalisation d'ouvrages en bijouterie, joaillerie et orfèvrerie"),
    Metier._("B1805", "Stylisme"),
    Metier._("B1602", "Réalisation d'objets artistiques et fonctionnels en verre"),
    Metier._("C1107", "Indemnisations en assurances"),
    Metier._("D1201", "Achat vente d'objets d'art, anciens ou d'occasion"),
    Metier._("C1206", "Gestion de clientèle bancaire"),
    Metier._("C1401", "Gestion en banque et assurance"),
    Metier._("C1501", "Gérance immobilière"),
    Metier._("D1402", "Relation commerciale grands comptes et entreprises"),
    Metier._("A1101", "Conduite d'engins agricoles et forestiers"),
    Metier._("A1205", "Sylviculture"),
    Metier._("A1303", "Ingénierie en agriculture et environnement naturel"),
    Metier._("A1203", "Aménagement et entretien des espaces verts"),
    Metier._("A1204", "Protection du patrimoine naturel"),
    Metier._("A1402", "Aide agricole de production légumière ou végétale"),
    Metier._("A1414", "Horticulture et maraîchage"),
    Metier._("B1201", "Réalisation d'objets décoratifs et utilitaires en céramique et matériaux de synthèse"),
    Metier._("A1202", "Entretien des espaces naturels"),
    Metier._("A1406", "Encadrement équipage de la pêche"),
    Metier._("A1411", "Élevage porcin"),
    Metier._("A1401", "Aide agricole de production fruitière ou viticole"),
    Metier._("A1404", "Aquaculture"),
    Metier._("A1407", "Élevage bovin ou équin"),
    Metier._("A1201", "Bûcheronnage et élagage"),
    Metier._("A1405", "Arboriculture et viticulture"),
    Metier._("N2101", "Navigation commerciale aérienne"),
    Metier._("N1302", "Direction de site logistique"),
    Metier._("N1301", "Conception et organisation de la chaîne logistique"),
    Metier._("N1303", "Intervention technique d'exploitation logistique"),
    Metier._("A1301", "Conseil et assistance technique en agriculture et environnement naturel"),
    Metier._("A1403", "Aide d'élevage agricole et aquacole"),
    Metier._("A1417", "Saliculture"),
    Metier._("A1302", "Contrôle et diagnostic technique en agriculture"),
    Metier._("A1408", "Élevage d'animaux sauvages ou de compagnie"),
    Metier._("B1303", "Gravure - ciselure"),
    Metier._("A1410", "Élevage ovin ou caprin"),
    Metier._("A1503", "Toilettage des animaux"),
    Metier._("B1701", "Conservation et reconstitution d'espèces animales"),
    Metier._("A1409", "Élevage de lapins et volailles"),
    Metier._("A1412", "Fabrication et affinage de fromages"),
    Metier._("A1413", "Fermentation de boissons alcoolisées"),
    Metier._("A1501", "Aide aux soins animaux"),
    Metier._("D1101", "Boucherie"),
    Metier._("D1208", "Soins esthétiques et corporels"),
    Metier._("D1209", "Vente de végétaux"),
    Metier._("E1103", "Communication"),
    Metier._("A1415", "Équipage de la pêche"),
    Metier._("C1503", "Management de projet immobilier"),
    Metier._("D1212", "Vente en décoration et équipement du foyer"),
    Metier._("D1301", "Management de magasin de détail"),
    Metier._("E1102", "Écriture d'ouvrages, de livres"),
    Metier._("E1302", "Conduite de machines de façonnage routage"),
    Metier._("E1308", "Intervention technique en industrie graphique"),
    Metier._("E1305", "Préparation et correction en édition et presse"),
    Metier._("E1307", "Reprographie"),
    Metier._("E1204", "Projection cinéma"),
    Metier._("E1205", "Réalisation de contenus multimédias"),
    Metier._("D1507", "Mise en rayon libre-service"),
    Metier._("E1101", "Animation de site multimédia"),
    Metier._("E1301", "Conduite de machines d'impression"),
    Metier._("E1401", "Développement et promotion publicitaire"),
    Metier._("D1404", "Relation commerciale en vente de véhicules"),
    Metier._("D1504", "Direction de magasin de grande distribution"),
    Metier._("D1509", "Management de département en grande distribution"),
    Metier._("E1303", "Encadrement des industries graphiques"),
    Metier._("D1501", "Animation de vente"),
    Metier._("D1503", "Management/gestion de rayon produits non alimentaires"),
    Metier._("E1107", "Organisation d'évènementiel"),
    Metier._("E1201", "Photographie"),
    Metier._("E1202", "Production en laboratoire cinématographique"),
    Metier._("E1203", "Production en laboratoire photographique"),
    Metier._("C1103", "Courtage en assurances"),
    Metier._("C1104", "Direction d'exploitation en assurances"),
    Metier._("C1203", "Relation clients banque/finance"),
    Metier._("D1207", "Retouches en habillement"),
    Metier._("C1303", "Gestion de portefeuilles sur les marchés financiers"),
    Metier._("D1107", "Vente en gros de produits frais"),
    Metier._("D1206", "Réparation d'articles en cuir et matériaux souples"),
    Metier._("E1104", "Conception de contenus multimédias"),
    Metier._("E1105", "Coordination d'édition"),
    Metier._("C1102", "Conseil clientèle en assurances"),
    Metier._("C1108", "Management de groupe et de service en assurances"),
    Metier._("D1103", "Charcuterie - traiteur"),
    Metier._("D1104", "Pâtisserie, confiserie, chocolaterie et glacerie"),
    Metier._("C1502", "Gestion locative immobilière"),
    Metier._("C1504", "Transaction immobilière"),
    Metier._("D1102", "Boulangerie - viennoiserie"),
    Metier._("D1202", "Coiffure"),
    Metier._("C1105", "Études actuarielles en assurances"),
    Metier._("C1109", "Rédaction et gestion en assurances"),
    Metier._("C1202", "Analyse de crédits et risques bancaires"),
    Metier._("C1207", "Management en exploitation bancaire"),
    Metier._("D1203", "Hydrothérapie"),
    Metier._("D1204", "Location de véhicules ou de matériel de loisirs"),
    Metier._("D1213", "Vente en gros de matériel et équipement"),
    Metier._("D1401", "Assistanat commercial"),
    Metier._("D1502", "Management/gestion de rayon produits alimentaires"),
    Metier._("D1508", "Encadrement du personnel de caisses"),
    Metier._("E1106", "Journalisme et information média"),
    Metier._("D1406", "Management en force de vente"),
    Metier._("D1407", "Relation technico-commerciale"),
    Metier._("D1408", "Téléconseil et télévente"),
    Metier._("E1108", "Traduction, interprétariat"),
    Metier._("E1304", "Façonnage et routage"),
    Metier._("E1306", "Prépresse"),
    Metier._("E1402", "Élaboration de plan média"),
    Metier._("D1105", "Poissonnerie"),
    Metier._("D1106", "Vente en alimentation"),
    Metier._("D1405", "Conseil en information médicale"),
    Metier._("D1505", "Personnel de caisse"),
    Metier._("D1506", "Marchandisage"),
    Metier._("D1205", "Nettoyage d'articles textiles ou cuirs"),
    Metier._("D1210", "Vente en animalerie"),
    Metier._("D1211", "Vente en articles de sport et loisirs"),
    Metier._("D1214", "Vente en habillement et accessoires de la personne"),
    Metier._("C1301", "Front office marchés financiers"),
    Metier._("L1510", "Films d'animation et effets spéciaux"),
  ];

  final String codeRome;
  final String libelle;

  Metier._(this.codeRome, this.libelle);

  @override
  List<Object?> get props => [codeRome, libelle];

  @override
  String toString() => libelle;
}
