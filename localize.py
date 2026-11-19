# -*- coding: utf-8 -*-
from pathlib import Path
import json,re
R=Path(__file__).resolve().parent/'BoraJogar/Resources'
rows=r'''A court for every game.|Uma quadra para cada jogo.|Ein Platz für jedes Spiel.|Un terrain pour chaque match.|Una cancha para cada partido.|Un campo per ogni partita.
A good game starts with respect.|Um bom jogo começa com respeito.|Ein gutes Spiel beginnt mit Respekt.|Un bon match commence par le respect.|Un buen partido empieza con respeto.|Una bella partita inizia dal rispetto.
Add a profile name first.|Adicione seu nome ao perfil.|Füge zuerst einen Profilnamen hinzu.|Ajoutez d'abord un nom de profil.|Primero añade un nombre al perfil.|Aggiungi prima un nome al profilo.
Add court|Adicionar quadra|Platz hinzufügen|Ajouter un terrain|Añadir cancha|Aggiungi campo
Add opponent|Adicionar adversário|Gegner hinzufügen|Ajouter un adversaire|Añadir rival|Aggiungi avversario
Add player|Adicionar jogador|Spieler hinzufügen|Ajouter un joueur|Añadir jugador|Aggiungi giocatore
Add players in Squad.|Adicione jogadores em Elenco.|Füge Spieler unter Kader hinzu.|Ajoutez des joueurs dans Effectif.|Añade jugadores en Plantilla.|Aggiungi giocatori in Rosa.
Add to Calendar|Adicionar ao Calendário|Zum Kalender hinzufügen|Ajouter au calendrier|Añadir al calendario|Aggiungi al calendario
Add your name and sign in with Apple first.|Adicione seu nome e entre com a Apple primeiro.|Füge deinen Namen hinzu und melde dich mit Apple an.|Ajoutez votre nom et connectez-vous avec Apple.|Añade tu nombre e inicia sesión con Apple.|Aggiungi il tuo nome e accedi con Apple.
Add your own court|Adicionar minha quadra|Eigenen Platz hinzufügen|Ajouter votre terrain|Añadir tu cancha|Aggiungi il tuo campo
Address|Endereço|Adresse|Adresse|Dirección|Indirizzo
Approve|Aprovar|Freigeben|Approuver|Aprobar|Approva
Approved messages|Mensagens aprovadas|Freigegebene Nachrichten|Messages approuvés|Mensajes aprobados|Messaggi approvati
Approximate location|Localização aproximada|Ungefährer Standort|Emplacement approximatif|Ubicación aproximada|Posizione approssimativa
Assist|Assistência|Vorlage|Passe décisive|Asistencia|Assist
Away goals|Gols do visitante|Auswärtstore|Buts à l'extérieur|Goles visitantes|Gol ospiti
Back up or restore organizer keys|Salvar ou restaurar chaves do organizador|Organisatorschlüssel sichern oder wiederherstellen|Sauvegarder ou restaurer les clés de l'organisateur|Guardar o restaurar claves del organizador|Salva o ripristina le chiavi dell'organizzatore
Block player|Bloquear jogador|Spieler sperren|Bloquer le joueur|Bloquear jugador|Blocca giocatore
Build a squad|Monte o elenco|Kader aufbauen|Créer un effectif|Crea tu plantilla|Crea una rosa
Can't play|Não vou|Bin nicht dabei|Indisponible|No puedo|Non posso
Cancel|Cancelar|Abbrechen|Annuler|Cancelar|Annulla
Cancel match|Cancelar jogo|Spiel absagen|Annuler le match|Cancelar partido|Annulla partita
Cancel this match?|Cancelar este jogo?|Dieses Spiel absagen?|Annuler ce match ?|¿Cancelar este partido?|Annullare questa partita?
Cancelled|Cancelado|Abgesagt|Annulé|Cancelado|Annullata
Choose|Escolher|Auswählen|Choisir|Elegir|Scegli
Choose a court, set kickoff and bring the squad.|Escolha a quadra, marque o horário e reúna o elenco.|Wähle einen Platz, lege den Anstoß fest und bring den Kader zusammen.|Choisissez un terrain, fixez le coup d'envoi et rassemblez l'effectif.|Elige cancha y horario y reúne a tu plantilla.|Scegli un campo, fissa l'orario e riunisci la rosa.
City|Cidade|Stadt|Ville|Ciudad|Città
Cloud conflict|Conflito no iCloud|iCloud-Konflikt|Conflit iCloud|Conflicto de iCloud|Conflitto iCloud
Cloud deletion did not finish. Your profile is kept so you can retry.|A exclusão no iCloud não terminou. Seu perfil foi mantido para tentar novamente.|Das Löschen in iCloud wurde nicht abgeschlossen. Dein Profil bleibt für einen erneuten Versuch erhalten.|La suppression iCloud n'est pas terminée. Votre profil est conservé pour réessayer.|No se completó la eliminación en iCloud. Tu perfil se conserva para reintentar.|Eliminazione iCloud non completata. Il profilo è conservato per riprovare.
Community football organized with Bora Jogar.|Futebol amador organizado com Bora Jogar.|Freizeitfußball organisiert mit Bora Jogar.|Football amateur organisé avec Bora Jogar.|Fútbol amateur organizado con Bora Jogar.|Calcio amatoriale organizzato con Bora Jogar.
Could not accept invitation.|Não foi possível aceitar o convite.|Einladung konnte nicht angenommen werden.|Impossible d'accepter l'invitation.|No se pudo aceptar la invitación.|Impossibile accettare l'invito.
Could not create a team invitation.|Não foi possível criar o convite.|Teameinladung konnte nicht erstellt werden.|Impossible de créer l'invitation d'équipe.|No se pudo crear la invitación.|Impossibile creare l'invito della squadra.
Could not find your location. Search by city instead.|Localização não encontrada. Busque pela cidade.|Standort nicht gefunden. Suche nach einer Stadt.|Position introuvable. Recherchez par ville.|No se encontró tu ubicación. Busca por ciudad.|Posizione non trovata. Cerca per città.
Could not save on this device.|Não foi possível salvar neste dispositivo.|Speichern auf diesem Gerät fehlgeschlagen.|Impossible d'enregistrer sur cet appareil.|No se pudo guardar en este dispositivo.|Impossibile salvare su questo dispositivo.
Court|Quadra|Platz|Terrain|Cancha|Campo
Court & season|Quadra e temporada|Platz und Saison|Terrain et saison|Cancha y temporada|Campo e stagione
Court details|Detalhes da quadra|Platzdetails|Détails du terrain|Detalles de la cancha|Dettagli del campo
Court name|Nome da quadra|Platzname|Nom du terrain|Nombre de la cancha|Nome del campo
Courts|Quadras|Plätze|Terrains|Canchas|Campi
Create|Criar|Erstellen|Créer|Crear|Crea
Create a team on Matchday first.|Crie uma equipe em Jogos primeiro.|Erstelle zuerst ein Team unter Spieltag.|Créez d'abord une équipe dans Matchs.|Primero crea un equipo en Jornada.|Crea prima una squadra in Partite.
Create another team|Criar outra equipe|Weiteres Team erstellen|Créer une autre équipe|Crear otro equipo|Crea un'altra squadra
Create match|Criar jogo|Spiel erstellen|Créer un match|Crear partido|Crea partita
Create season|Criar temporada|Saison erstellen|Créer une saison|Crear temporada|Crea stagione
Create team|Criar equipe|Team erstellen|Créer une équipe|Crear equipo|Crea squadra
Create your team|Crie sua equipe|Erstelle dein Team|Créez votre équipe|Crea tu equipo|Crea la tua squadra
D|E|U|N|E|N
Defense|Defesa|Abwehr|Défense|Defensa|Difesa
Delete profile & data|Excluir perfil e dados|Profil und Daten löschen|Supprimer le profil et les données|Eliminar perfil y datos|Elimina profilo e dati
Delete your profile, local data and your iCloud team records? This cannot be undone.|Excluir seu perfil, dados locais e registros da equipe no iCloud? Esta ação é irreversível.|Profil, lokale Daten und deine iCloud-Teamdaten löschen? Dies kann nicht rückgängig gemacht werden.|Supprimer le profil, les données locales et vos données d'équipe iCloud ? Cette action est irréversible.|¿Eliminar perfil, datos locales y tus registros de equipo en iCloud? No se puede deshacer.|Eliminare profilo, dati locali e i tuoi dati squadra su iCloud? L'azione è irreversibile.
Directory|Diretório|Verzeichnis|Annuaire|Directorio|Elenco
Done|Concluir|Fertig|Terminé|Listo|Fine
Enable|Ativar|Aktivieren|Activer|Activar|Attiva
End countdown|Encerrar contagem|Countdown beenden|Arrêter le compte à rebours|Finalizar cuenta atrás|Termina conto alla rovescia
Every game counts.|Cada jogo conta.|Jedes Spiel zählt.|Chaque match compte.|Cada partido cuenta.|Ogni partita conta.
Export device data|Exportar dados do dispositivo|Gerätedaten exportieren|Exporter les données de l'appareil|Exportar datos del dispositivo|Esporta dati del dispositivo
Final score|Placar final|Endergebnis|Score final|Resultado final|Risultato finale
Finding nearby courts…|Buscando quadras próximas…|Plätze in der Nähe werden gesucht…|Recherche de terrains proches…|Buscando canchas cercanas…|Ricerca campi vicini…
Fixture|Jogo|Begegnung|Rencontre|Encuentro|Incontro
Forward|Ataque|Sturm|Attaque|Delantera|Attacco
Free, without ads or purchases. Designed for community football.|Grátis, sem anúncios nem compras. Feito para o futebol amador.|Kostenlos, ohne Werbung oder Käufe. Für Freizeitfußball entwickelt.|Gratuit, sans publicité ni achats. Conçu pour le football amateur.|Gratis, sin anuncios ni compras. Para el fútbol amateur.|Gratis, senza pubblicità o acquisti. Per il calcio amatoriale.
Friendly match|Amistoso|Freundschaftsspiel|Match amical|Amistoso|Amichevole
GA|GC|GT|BC|GC|GS
GD|SG|TD|DB|DG|DR
GET YOUR TEAM TOGETHER|REÚNA SUA EQUIPE|BRING DEIN TEAM ZUSAMMEN|RASSEMBLEZ VOTRE ÉQUIPE|REÚNE A TU EQUIPO|RIUNISCI LA TUA SQUADRA
GF|GP|T|BP|GF|GF
Goal log|Registro de gols|Torprotokoll|Journal des buts|Registro de goles|Registro gol
Goalkeeper|Goleiro|Torwart|Gardien|Portero|Portiere
Going|Confirmado|Dabei|Présent|Confirmado|Presente
Have an invitation? Open the iCloud link from your organizer.|Recebeu um convite? Abra o link do iCloud enviado pelo organizador.|Hast du eine Einladung? Öffne den iCloud-Link deines Organisators.|Une invitation ? Ouvrez le lien iCloud de l'organisateur.|¿Tienes invitación? Abre el enlace de iCloud del organizador.|Hai un invito? Apri il link iCloud dell'organizzatore.
Hide author|Ocultar autor|Autor ausblenden|Masquer l'auteur|Ocultar autor|Nascondi autore
Home goals|Gols do mandante|Heimtore|Buts à domicile|Goles locales|Gol in casa
Home team|Mandante|Heimteam|Équipe à domicile|Equipo local|Squadra di casa
I'm in|Eu vou|Bin dabei|Je participe|Me apunto|Ci sono
Invitation accepted|Convite aceito|Einladung angenommen|Invitation acceptée|Invitación aceptada|Invito accettato
Invitations|Convites|Einladungen|Invitations|Invitaciones|Inviti
Invite with iCloud link|Convidar com link do iCloud|Mit iCloud-Link einladen|Inviter avec un lien iCloud|Invitar con enlace de iCloud|Invita con link iCloud
Keep this device's version|Manter versão deste dispositivo|Version dieses Geräts behalten|Garder la version de cet appareil|Conservar versión del dispositivo|Mantieni versione del dispositivo
Kickoff|Início|Anstoß|Coup d'envoi|Inicio|Calcio d'inizio
L|D|N|D|D|P
Last result|Último resultado|Letztes Ergebnis|Dernier résultat|Último resultado|Ultimo risultato
Latitude|Latitude|Breitengrad|Latitude|Latitud|Latitudine
Less planning.\nMore playing.|Menos planejamento.\nMais jogo.|Weniger planen.\nMehr spielen.|Moins prévoir.\nPlus jouer.|Menos planes.\nMás juego.|Meno piani.\nPiù gioco.
Lineup|Escalação|Aufstellung|Composition|Alineación|Formazione
Links and contact details are not allowed in chat.|Links e contatos não são permitidos no chat.|Links und Kontaktdaten sind im Chat nicht erlaubt.|Les liens et coordonnées sont interdits dans le chat.|No se permiten enlaces ni contactos en el chat.|Link e contatti non sono consentiti in chat.
Live Activities are disabled in Settings.|As Atividades ao Vivo estão desativadas nos Ajustes.|Live-Aktivitäten sind in den Einstellungen deaktiviert.|Les activités en direct sont désactivées dans Réglages.|Las actividades en directo están desactivadas en Ajustes.|Le attività in tempo reale sono disattivate in Impostazioni.
Local data could not be read. Keep a copy before deleting the app.|Não foi possível ler os dados locais. Guarde uma cópia antes de excluir o app.|Lokale Daten konnten nicht gelesen werden. Sichere eine Kopie, bevor du die App löschst.|Données locales illisibles. Gardez une copie avant de supprimer l'app.|No se pudieron leer los datos locales. Guarda una copia antes de eliminar la app.|Dati locali illeggibili. Conserva una copia prima di eliminare l'app.
Local only|Somente local|Nur lokal|Local uniquement|Solo local|Solo locale
Location is unavailable. Search by city instead.|Localização indisponível. Busque pela cidade.|Standort nicht verfügbar. Suche nach einer Stadt.|Position indisponible. Recherchez par ville.|Ubicación no disponible. Busca por ciudad.|Posizione non disponibile. Cerca per città.
Longitude|Longitude|Längengrad|Longitude|Longitud|Longitudine
Map|Mapa|Karte|Carte|Mapa|Mappa
Match calendar|Calendário de jogos|Spielkalender|Calendrier des matchs|Calendario de partidos|Calendario partite
Match details|Detalhes do jogo|Spieldetails|Détails du match|Detalles del partido|Dettagli partita
Match not found.|Jogo não encontrado.|Spiel nicht gefunden.|Match introuvable.|Partido no encontrado.|Partita non trovata.
Match reminders|Lembretes de jogos|Spielerinnerungen|Rappels de matchs|Recordatorios de partidos|Promemoria partite
Match tomorrow|Jogo amanhã|Morgen ist Spieltag|Match demain|Partido mañana|Partita domani
Matchday|Jogos|Spieltag|Matchs|Jornada|Partite
Maybe|Talvez|Vielleicht|Peut-être|Quizá|Forse
Membership request|Pedido para entrar|Beitrittsanfrage|Demande d'adhésion|Solicitud de ingreso|Richiesta di adesione
Message for review|Mensagem para revisão|Nachricht zur Prüfung|Message à examiner|Mensaje para revisión|Messaggio da approvare
Message report|Denúncia de mensagem|Nachrichtenmeldung|Signalement de message|Denuncia de mensaje|Segnalazione messaggio
Midfield|Meio-campo|Mittelfeld|Milieu|Mediocampo|Centrocampo
Minute|Minuto|Minute|Minute|Minuto|Minuto
Minutes|Minutos|Minuten|Minutes|Minutos|Minuti
NEXT KICKOFF|PRÓXIMO JOGO|NÄCHSTER ANSTOSS|PROCHAIN COUP D'ENVOI|PRÓXIMO PARTIDO|PROSSIMO INCONTRO
Name|Nome|Name|Nom|Nombre|Nome
Nearby|Perto de mim|In der Nähe|À proximité|Cerca de mí|Nelle vicinanze
No matches yet.|Nenhum jogo ainda.|Noch keine Spiele.|Aucun match pour l'instant.|Aún no hay partidos.|Ancora nessuna partita.
No response|Sem resposta|Keine Antwort|Sans réponse|Sin respuesta|Nessuna risposta
No upcoming match|Nenhum próximo jogo|Kein anstehendes Spiel|Aucun match à venir|Sin próximos partidos|Nessuna partita in programma
None|Nenhuma|Keine|Aucune|Ninguna|Nessuno
Nothing waiting for review.|Nenhuma revisão pendente.|Nichts zur Prüfung offen.|Rien à examiner.|Nada pendiente de revisión.|Nessuna revisione in attesa.
Notifications are disabled. You can enable them in Settings.|Notificações desativadas. Ative-as nos Ajustes.|Mitteilungen sind deaktiviert. Aktiviere sie in den Einstellungen.|Notifications désactivées. Activez-les dans Réglages.|Notificaciones desactivadas. Actívalas en Ajustes.|Notifiche disattivate. Attivale in Impostazioni.
Only the organizer can change this.|Somente o organizador pode alterar isto.|Nur der Organisator kann dies ändern.|Seul l'organisateur peut modifier ceci.|Solo el organizador puede cambiarlo.|Solo l'organizzatore può modificarlo.
Only the organizer can invite participants.|Somente o organizador pode convidar participantes.|Nur der Organisator kann Teilnehmer einladen.|Seul l'organisateur peut inviter des participants.|Solo el organizador puede invitar participantes.|Solo l'organizzatore può invitare partecipanti.
Open in Maps|Abrir no Mapas|In Karten öffnen|Ouvrir dans Plans|Abrir en Mapas|Apri in Mappe
Opponent|Adversário|Gegner|Adversaire|Rival|Avversario
Opponent confirmed|Adversário confirmado|Gegner bestätigt|Adversaire confirmé|Rival confirmado|Avversario confermato
Opponents|Adversários|Gegner|Adversaires|Rivales|Avversari
Organizer|Organizador|Organisator|Organisateur|Organizador|Organizzatore
Organizer keys backed up or restored in private iCloud.|Chaves salvas ou restauradas no iCloud privado.|Organisatorschlüssel in privatem iCloud gesichert oder wiederhergestellt.|Clés sauvegardées ou restaurées dans l'iCloud privé.|Claves guardadas o restauradas en iCloud privado.|Chiavi salvate o ripristinate nell'iCloud privato.
Organizer protocol|Protocolo do organizador|Organisatorprotokoll|Feuille de l'organisateur|Acta del organizador|Referto dell'organizzatore
Organizer review|Revisão do organizador|Prüfung durch Organisator|Examen de l'organisateur|Revisión del organizador|Revisione dell'organizzatore
P|J|S|J|J|G
Participant|Participante|Teilnehmer|Participant|Participante|Partecipante
Pending organizer review.|Aguardando revisão do organizador.|Wartet auf Prüfung durch den Organisator.|En attente de l'examen de l'organisateur.|Pendiente de revisión del organizador.|In attesa di revisione dell'organizzatore.
Plan a match|Marque um jogo|Spiel planen|Planifier un match|Organiza un partido|Organizza una partita
Played|Jogos|Gespielt|Joués|Jugados|Giocate
Player statistics|Estatísticas dos jogadores|Spielerstatistik|Statistiques des joueurs|Estadísticas de jugadores|Statistiche giocatori
Players|Jogadores|Spieler|Joueurs|Jugadores|Giocatori
Position|Posição|Position|Poste|Posición|Ruolo
Privacy & community rules|Privacidade e regras da comunidade|Datenschutz und Gemeinschaftsregeln|Confidentialité et règles de communauté|Privacidad y normas de comunidad|Privacy e regole della comunità
Profile|Perfil|Profil|Profil|Perfil|Profilo
Profile & privacy|Perfil e privacidade|Profil und Datenschutz|Profil et confidentialité|Perfil y privacidad|Profilo e privacy
Profile and device data deleted.|Perfil e dados do dispositivo excluídos.|Profil und Gerätedaten gelöscht.|Profil et données de l'appareil supprimés.|Perfil y datos del dispositivo eliminados.|Profilo e dati del dispositivo eliminati.
Pts|Pts|Pkt|Pts|Pts|Pt
Queued for organizer review. Open sync to send.|Na fila de revisão. Sincronize para enviar.|Zur Prüfung vorgemerkt. Synchronisiere zum Senden.|En attente d'examen. Synchronisez pour envoyer.|En cola para revisión. Sincroniza para enviar.|In coda per revisione. Sincronizza per inviare.
RSVP|Presença|Teilnahme|Présence|Asistencia|Presenza
Record goal|Registrar gol|Tor eintragen|Noter le but|Registrar gol|Registra gol
Recovered the last local backup.|Último backup local restaurado.|Letzte lokale Sicherung wiederhergestellt.|Dernière sauvegarde locale restaurée.|Última copia local recuperada.|Ultimo backup locale recuperato.
Reject|Rejeitar|Ablehnen|Refuser|Rechazar|Rifiuta
Reminders|Lembretes|Erinnerungen|Rappels|Recordatorios|Promemoria
Removed player|Jogador removido|Entfernter Spieler|Joueur supprimé|Jugador eliminado|Giocatore rimosso
Report|Denunciar|Melden|Signaler|Denunciar|Segnala
Report saved for the organizer. This author is hidden on your device.|Denúncia salva para o organizador. Autor oculto neste dispositivo.|Meldung für den Organisator gespeichert. Der Autor ist auf deinem Gerät ausgeblendet.|Signalement enregistré pour l'organisateur. Cet auteur est masqué sur votre appareil.|Denuncia guardada para el organizador. El autor está oculto en tu dispositivo.|Segnalazione salvata per l'organizzatore. L'autore è nascosto sul dispositivo.
Request a place in the squad|Pedir vaga no elenco|Platz im Kader anfragen|Demander une place dans l'effectif|Solicitar plaza en la plantilla|Richiedi posto in rosa
Save|Salvar|Speichern|Enregistrer|Guardar|Salva
Saved locally|Salvo localmente|Lokal gespeichert|Enregistré localement|Guardado localmente|Salvato localmente
Saved opponents|Adversários salvos|Gespeicherte Gegner|Adversaires enregistrés|Rivales guardados|Avversari salvati
Scheduled|Agendados|Geplant|Prévus|Programados|Programmate
Scorer|Autor do gol|Torschütze|Buteur|Goleador|Marcatore
Search by city instead.|Busque pela cidade.|Suche nach einer Stadt.|Recherchez par ville.|Busca por ciudad.|Cerca per città.
Search city or court|Buscar cidade ou quadra|Stadt oder Platz suchen|Chercher une ville ou un terrain|Buscar ciudad o cancha|Cerca città o campo
Season|Temporada|Saison|Saison|Temporada|Stagione
Season name|Nome da temporada|Saisonname|Nom de la saison|Nombre de temporada|Nome stagione
Selected|Selecionado|Ausgewählt|Sélectionné|Seleccionado|Selezionato
Shirt number|Número da camisa|Trikotnummer|Numéro de maillot|Número de camiseta|Numero maglia
Sign in with Apple to send team messages.|Entre com a Apple para enviar mensagens à equipe.|Melde dich mit Apple an, um Teamnachrichten zu senden.|Connectez-vous avec Apple pour envoyer des messages.|Inicia sesión con Apple para enviar mensajes.|Accedi con Apple per inviare messaggi alla squadra.
Signed in with Apple|Conectado com a Apple|Mit Apple angemeldet|Connecté avec Apple|Sesión iniciada con Apple|Accesso con Apple effettuato
Sorted by approximate distance.|Ordenado por distância aproximada.|Nach ungefährer Entfernung sortiert.|Trié par distance approximative.|Ordenado por distancia aproximada.|Ordinato per distanza approssimativa.
Squad|Elenco|Kader|Effectif|Plantilla|Rosa
Standings|Classificação|Tabelle|Classement|Clasificación|Classifica
Start kickoff countdown|Iniciar contagem para o jogo|Anstoß-Countdown starten|Lancer le compte à rebours|Iniciar cuenta atrás|Avvia conto alla rovescia
Start the countdown within 8 hours of kickoff.|Inicie a contagem nas 8 horas antes do jogo.|Starte den Countdown innerhalb von 8 Stunden vor dem Anstoß.|Lancez le compte à rebours dans les 8 heures avant le match.|Inicia la cuenta atrás dentro de las 8 horas antes del partido.|Avvia il conto alla rovescia nelle 8 ore prima della partita.
Sync could not finish. Unsynced changes remain on this device.|A sincronização não terminou. Alterações não enviadas ficam neste dispositivo.|Synchronisierung nicht abgeschlossen. Ungesendete Änderungen bleiben auf diesem Gerät.|Synchronisation inachevée. Les changements non envoyés restent sur cet appareil.|No se completó la sincronización. Los cambios no enviados quedan en este dispositivo.|Sincronizzazione incompleta. Le modifiche non inviate restano sul dispositivo.
Sync now|Sincronizar agora|Jetzt synchronisieren|Synchroniser|Sincronizar ahora|Sincronizza ora
Sync team|Sincronizar equipe|Team synchronisieren|Synchroniser l'équipe|Sincronizar equipo|Sincronizza squadra
Sync unavailable|Sincronização indisponível|Synchronisierung nicht verfügbar|Synchronisation indisponible|Sincronización no disponible|Sincronizzazione non disponibile
Synced on this device|Sincronizado neste dispositivo|Auf diesem Gerät synchronisiert|Synchronisé sur cet appareil|Sincronizado en este dispositivo|Sincronizzato su questo dispositivo
Team|Equipe|Team|Équipe|Equipo|Squadra
Team chat|Chat da equipe|Teamchat|Chat d'équipe|Chat del equipo|Chat squadra
Team name|Nome da equipe|Teamname|Nom de l'équipe|Nombre del equipo|Nome squadra
Teams|Equipes|Teams|Équipes|Equipos|Squadre
The next game starts here.|O próximo jogo começa aqui.|Das nächste Spiel beginnt hier.|Le prochain match commence ici.|El próximo partido empieza aquí.|La prossima partita inizia qui.
Track a season|Acompanhe a temporada|Saison verfolgen|Suivre une saison|Sigue la temporada|Segui la stagione
Unavailable|Indisponível|Nicht verfügbar|Indisponible|No disponible|Non disponibile
Unhide authors on this device|Reexibir autores neste dispositivo|Autoren auf diesem Gerät einblenden|Réafficher les auteurs sur cet appareil|Mostrar autores en este dispositivo|Mostra autori su questo dispositivo
Updated|Atualizado|Aktualisiert|Mis à jour|Actualizado|Aggiornato
Use cloud version|Usar versão do iCloud|iCloud-Version verwenden|Utiliser la version iCloud|Usar versión de iCloud|Usa versione iCloud
Venue source|Fonte da quadra|Platzquelle|Source du terrain|Fuente de la cancha|Fonte del campo
W|V|S|V|V|V
Your attendance|Sua presença|Deine Teilnahme|Votre présence|Tu asistencia|La tua presenza
Your data|Seus dados|Deine Daten|Vos données|Tus datos|I tuoi dati
Your name|Seu nome|Dein Name|Votre nom|Tu nombre|Il tuo nome
Your next result starts on the pitch.|Seu próximo resultado começa em campo.|Dein nächstes Ergebnis beginnt auf dem Platz.|Votre prochain résultat commence sur le terrain.|Tu próximo resultado empieza en la cancha.|Il prossimo risultato inizia in campo.
Your participation is blocked by the organizer.|Sua participação foi bloqueada pelo organizador.|Deine Teilnahme wurde vom Organisator gesperrt.|Votre participation est bloquée par l'organisateur.|El organizador ha bloqueado tu participación.|La tua partecipazione è bloccata dall'organizzatore.
Your team|Sua equipe|Dein Team|Votre équipe|Tu equipo|La tua squadra
appearances|participações|Einsätze|présences|apariciones|presenze
assists|assistências|Vorlagen|passes décisives|asistencias|assist
 goals| gols| Tore| buts| goles| gol
goals|gols|Tore|buts|goles|gol
going|confirmados|dabei|présents|confirmados|presenti
iCloud collaboration|Colaboração no iCloud|iCloud-Zusammenarbeit|Collaboration iCloud|Colaboración con iCloud|Collaborazione iCloud
played|jogos|gespielt|joués|jugados|giocate
requests waiting to sync|solicitações aguardando sincronização|Anfragen warten auf Synchronisierung|demandes en attente de synchronisation|solicitudes pendientes de sincronizar|richieste in attesa di sincronizzazione
wins|vitórias|Siege|victoires|victorias|vittorie'''
long=r'''3 points for a win, 1 for a draw. Ties: goal difference, goals scored, team name. Cancelled matches do not count.|Vitória: 3 pontos; empate: 1. Desempate: saldo de gols, gols marcados e nome da equipe. Jogos cancelados não contam.|Sieg: 3 Punkte, Unentschieden: 1. Gleichstand: Tordifferenz, erzielte Tore, Teamname. Abgesagte Spiele zählen nicht.|Victoire : 3 points, nul : 1. Égalité : différence de buts, buts marqués, nom d'équipe. Les matchs annulés ne comptent pas.|Victoria: 3 puntos; empate: 1. Desempate: diferencia de goles, goles marcados y nombre. Los partidos cancelados no cuentan.|Vittoria: 3 punti; pareggio: 1. Parità: differenza reti, gol segnati e nome squadra. Le partite annullate non contano.
Attendance syncs when the app opens. Unsynced responses stay on this device.|A presença sincroniza ao abrir o app. Respostas não enviadas ficam neste dispositivo.|Teilnahmen werden beim Öffnen synchronisiert. Ungesendete Antworten bleiben auf diesem Gerät.|La présence se synchronise à l'ouverture. Les réponses non envoyées restent sur cet appareil.|La asistencia se sincroniza al abrir la app. Las respuestas sin enviar quedan aquí.|La presenza si sincronizza all'apertura. Le risposte non inviate restano sul dispositivo.
Coordinates are optional to obtain from Maps, but required to place your court accurately in this directory.|Você pode obter as coordenadas no Mapas. Elas são necessárias para localizar a quadra no diretório.|Du kannst Koordinaten aus Karten übernehmen. Sie sind zur Positionierung des Platzes erforderlich.|Vous pouvez obtenir les coordonnées dans Plans. Elles sont nécessaires pour situer le terrain.|Puedes obtener coordenadas en Mapas. Son necesarias para ubicar la cancha.|Puoi ottenere le coordinate in Mappe. Servono per posizionare il campo nell'elenco.
Court details are an offline directory. Contact the venue yourself to check access; creating a match does not reserve a court.|Este é um diretório offline. Confirme o acesso com o local; criar um jogo não reserva a quadra.|Die Platzdaten sind ein Offline-Verzeichnis. Kläre den Zugang selbst; ein Spiel zu erstellen reserviert keinen Platz.|L'annuaire est hors ligne. Vérifiez l'accès auprès du lieu ; créer un match ne réserve pas le terrain.|Es un directorio sin conexión. Confirma el acceso con el lugar; crear un partido no reserva cancha.|È un elenco offline. Verifica l'accesso con la struttura; creare una partita non prenota il campo.
Create a season to group fixtures and build a table from final scores.|Crie uma temporada para agrupar jogos e gerar a classificação pelos placares finais.|Erstelle eine Saison, um Spiele zu gruppieren und eine Tabelle aus Endergebnissen zu berechnen.|Créez une saison pour regrouper les matchs et calculer le classement à partir des scores finaux.|Crea una temporada para agrupar partidos y calcular la tabla con resultados finales.|Crea una stagione per raggruppare le partite e calcolare la classifica dai risultati finali.
Get a reminder the day before kickoff. Your match calendar works if you decline.|Receba um lembrete na véspera do jogo. O calendário funciona mesmo se você recusar.|Erhalte am Vortag eine Erinnerung. Der Spielkalender funktioniert auch ohne Erlaubnis.|Recevez un rappel la veille. Le calendrier fonctionne même en cas de refus.|Recibe un recordatorio el día anterior. El calendario funciona si lo rechazas.|Ricevi un promemoria il giorno prima. Il calendario funziona anche se rifiuti.
Invitations use iCloud. The organizer reviews membership and team messages. No public chat or live push service.|Os convites usam iCloud. O organizador revisa membros e mensagens. Sem chat público ou notificações em tempo real.|Einladungen nutzen iCloud. Der Organisator prüft Beitritte und Nachrichten. Kein öffentlicher Chat oder Echtzeit-Pushdienst.|Les invitations utilisent iCloud. L'organisateur examine les adhésions et messages. Pas de chat public ni de notifications en temps réel.|Las invitaciones usan iCloud. El organizador revisa miembros y mensajes. Sin chat público ni avisos en tiempo real.|Gli inviti usano iCloud. L'organizzatore esamina adesioni e messaggi. Nessuna chat pubblica o notifica in tempo reale.
Keep teams you know here, then select them when creating a match. Share invitations through the system sheet.|Salve equipes conhecidas e selecione-as ao criar jogos. Compartilhe convites pela folha do sistema.|Speichere bekannte Teams und wähle sie beim Erstellen eines Spiels. Teile Einladungen über das Systemmenü.|Enregistrez les équipes connues et choisissez-les à la création d'un match. Partagez les invitations via le système.|Guarda equipos conocidos y selecciónalos al crear partidos. Comparte invitaciones con el sistema.|Salva le squadre conosciute e selezionale quando crei una partita. Condividi gli inviti tramite il sistema.
Local reminders for tomorrow's match and newly confirmed opponents. No real-time delivery is promised.|Lembretes locais do jogo de amanhã e de adversários confirmados. Sem promessa de envio em tempo real.|Lokale Erinnerungen an morgige Spiele und neu bestätigte Gegner. Keine Echtzeitzustellung zugesagt.|Rappels locaux pour les matchs du lendemain et adversaires confirmés. Aucune livraison en temps réel promise.|Recordatorios locales para partidos de mañana y rivales confirmados. Sin garantía de entrega en tiempo real.|Promemoria locali per le partite di domani e gli avversari confermati. Nessuna consegna in tempo reale garantita.
Map tiles need a connection. The court list remains available offline.|O mapa precisa de conexão. A lista de quadras funciona offline.|Karten benötigen eine Verbindung. Die Platzliste bleibt offline verfügbar.|La carte nécessite une connexion. La liste des terrains reste disponible hors ligne.|El mapa necesita conexión. La lista de canchas funciona sin conexión.|La mappa richiede una connessione. L'elenco campi resta disponibile offline.
Messages appear after organizer approval. No links, personal contacts or abusive content. Reports hide the author immediately on your device.|Mensagens aparecem após aprovação do organizador. Sem links, contatos pessoais ou ofensas. Denúncias ocultam o autor imediatamente neste dispositivo.|Nachrichten erscheinen nach Freigabe durch den Organisator. Keine Links, Kontaktdaten oder beleidigenden Inhalte. Meldungen blenden den Autor sofort auf deinem Gerät aus.|Les messages apparaissent après approbation. Aucun lien, contact personnel ou contenu abusif. Un signalement masque immédiatement l'auteur sur votre appareil.|Los mensajes aparecen tras la aprobación. Sin enlaces, contactos personales ni contenido abusivo. Denunciar oculta al autor en tu dispositivo.|I messaggi appaiono dopo l'approvazione. Niente link, contatti personali o contenuti offensivi. Le segnalazioni nascondono subito l'autore sul dispositivo.
Offline directory · approximate map pins. Access, opening hours and availability must be confirmed with the venue.|Diretório offline · pontos aproximados. Confirme acesso, horários e disponibilidade com o local.|Offline-Verzeichnis · ungefähre Kartenpunkte. Zugang, Öffnungszeiten und Verfügbarkeit beim Betreiber prüfen.|Annuaire hors ligne · repères approximatifs. Confirmez accès, horaires et disponibilité auprès du lieu.|Directorio sin conexión · puntos aproximados. Confirma acceso, horarios y disponibilidad con el lugar.|Elenco offline · punti approssimativi. Conferma accesso, orari e disponibilità con la struttura.
Offline tools work without an account. iCloud is needed for shared teams; Apple sign-in identifies your chat profile. Changes are checked when you open the app or tap Sync.|As ferramentas offline funcionam sem conta. Equipes compartilhadas usam iCloud; o login Apple identifica seu perfil no chat. As alterações são verificadas ao abrir o app ou sincronizar.|Offline-Werkzeuge funktionieren ohne Konto. Geteilte Teams benötigen iCloud; die Apple-Anmeldung identifiziert dein Chatprofil. Änderungen werden beim Öffnen oder Synchronisieren geprüft.|Les outils hors ligne fonctionnent sans compte. Les équipes partagées nécessitent iCloud ; la connexion Apple identifie le profil de chat. Les changements sont vérifiés à l'ouverture ou à la synchronisation.|Las herramientas sin conexión funcionan sin cuenta. Los equipos compartidos requieren iCloud; el acceso con Apple identifica tu perfil de chat. Se comprueban cambios al abrir o sincronizar.|Gli strumenti offline funzionano senza account. Le squadre condivise richiedono iCloud; l'accesso Apple identifica il profilo chat. Le modifiche si verificano all'apertura o alla sincronizzazione.
Only final protocols count toward standings. Player goals are recorded separately and must match the team score.|Somente placares finais contam na classificação. Os gols individuais são registrados separadamente e devem corresponder ao placar.|Nur Endergebnisse zählen für die Tabelle. Spielertore werden getrennt erfasst und müssen zum Teamergebnis passen.|Seuls les scores finaux comptent au classement. Les buts individuels sont saisis séparément et doivent correspondre au score.|Solo los resultados finales cuentan en la tabla. Los goles individuales se registran aparte y deben coincidir con el marcador.|Solo i risultati finali contano in classifica. I gol individuali si registrano separatamente e devono coincidere col punteggio.
Team scores, your next kickoff and the season table, from your device.|Placares da equipe, próximo jogo e classificação, direto do dispositivo.|Teamergebnisse, nächster Anstoß und Saisontabelle von deinem Gerät.|Scores, prochain match et classement depuis votre appareil.|Resultados, próximo partido y clasificación desde tu dispositivo.|Risultati, prossima partita e classifica dal dispositivo.
Teams are added to the table when fixtures are created in this season.|Equipes entram na tabela ao criar jogos nesta temporada.|Teams werden beim Erstellen von Saisonspielen zur Tabelle hinzugefügt.|Les équipes sont ajoutées au classement à la création des matchs de la saison.|Los equipos se añaden al crear partidos en esta temporada.|Le squadre si aggiungono alla classifica creando partite nella stagione.
This is a reference listing, not a reservation service. Check the venue before traveling.|Listagem de referência. Não é serviço de reservas. Confira com o local antes de ir.|Dies ist ein Verzeichniseintrag, kein Reservierungsdienst. Prüfe den Platz vor der Anreise.|Ceci est une fiche de référence, pas un service de réservation. Vérifiez le lieu avant de partir.|Es una referencia, no un servicio de reservas. Consulta al lugar antes de viajar.|È una scheda informativa, non un servizio di prenotazione. Verifica prima di partire.
You are the organizer. Create matches, approve chat and invite players when you're ready.|Você é o organizador. Crie jogos, aprove mensagens e convide jogadores quando quiser.|Du bist der Organisator. Erstelle Spiele, prüfe Nachrichten und lade Spieler ein.|Vous êtes l'organisateur. Créez des matchs, approuvez les messages et invitez des joueurs.|Eres el organizador. Crea partidos, aprueba mensajes e invita jugadores.|Sei l'organizzatore. Crea partite, approva messaggi e invita giocatori.
Your squad, your court, your next match. All in one place, even offline.|Seu elenco, sua quadra e seu próximo jogo. Tudo junto, até offline.|Dein Kader, dein Platz, dein nächstes Spiel. Alles an einem Ort, auch offline.|Votre effectif, votre terrain, votre prochain match. Tout au même endroit, même hors ligne.|Tu plantilla, tu cancha y tu próximo partido. Todo junto, incluso sin conexión.|La tua rosa, il tuo campo, la prossima partita. Tutto insieme, anche offline.'''
privacy=r'''Data stays on this device until you enable iCloud. Teams and approved chat are shared only through team invitations. No tracking, advertising, analytics or own server is used.|Os dados ficam neste dispositivo até ativar o iCloud. Equipes e chat aprovado são compartilhados por convites. Sem rastreamento, anúncios, análise ou servidor próprio.|Daten bleiben auf diesem Gerät, bis du iCloud aktivierst. Teams und freigegebene Chats werden nur über Einladungen geteilt. Kein Tracking, Werbung, Analyse oder eigener Server.|Les données restent sur l'appareil avant l'activation d'iCloud. Les équipes et messages approuvés sont partagés par invitation. Aucun suivi, publicité, analyse ou serveur propre.|Los datos quedan en el dispositivo hasta activar iCloud. Equipos y chat aprobado se comparten por invitación. Sin rastreo, anuncios, analítica ni servidor propio.|I dati restano sul dispositivo finché attivi iCloud. Squadre e chat approvata si condividono solo con inviti. Nessun tracciamento, pubblicità, analisi o server proprio.
Pending messages and reports are encrypted for the organizer. CloudKit transports and stores records. Apple account services use Apple's privacy terms. Location is used only to sort courts and is never sent to the team.|Mensagens pendentes e denúncias são criptografadas para o organizador. CloudKit transporta e armazena registros. Serviços Apple seguem seus termos de privacidade. Localização serve apenas para ordenar quadras e não é enviada à equipe.|Offene Nachrichten und Meldungen sind für den Organisator verschlüsselt. CloudKit überträgt und speichert Datensätze. Für Apple-Dienste gelten Apples Datenschutzbedingungen. Der Standort sortiert nur Plätze und wird nie ans Team gesendet.|Les messages en attente et signalements sont chiffrés pour l'organisateur. CloudKit transporte et stocke les données. Les services Apple suivent leurs règles de confidentialité. La position sert uniquement à trier les terrains et n'est jamais envoyée à l'équipe.|Los mensajes pendientes y denuncias se cifran para el organizador. CloudKit transporta y almacena datos. Los servicios Apple siguen sus términos de privacidad. La ubicación solo ordena canchas y nunca se envía al equipo.|Messaggi in attesa e segnalazioni sono cifrati per l'organizzatore. CloudKit trasporta e archivia i dati. I servizi Apple seguono i termini privacy Apple. La posizione ordina solo i campi e non viene mai inviata alla squadra.
Be kind. Do not share personal contacts, external links or harmful content. Organizers review messages before publication, reject content, handle reports and block participants. Use Report below a message to reach your organizer.|Respeite os outros. Não compartilhe contatos pessoais, links ou conteúdo nocivo. Organizadores revisam mensagens, rejeitam conteúdo, tratam denúncias e bloqueiam participantes. Use Denunciar abaixo da mensagem.|Sei freundlich. Teile keine Kontaktdaten, externen Links oder schädlichen Inhalte. Organisatoren prüfen Nachrichten vor Veröffentlichung, lehnen Inhalte ab, bearbeiten Meldungen und sperren Teilnehmer. Nutze Melden unter der Nachricht.|Restez respectueux. Ne partagez ni contacts personnels, ni liens, ni contenu nuisible. L'organisateur examine les messages avant publication, refuse les contenus, traite les signalements et bloque des membres. Utilisez Signaler sous un message.|Sé respetuoso. No compartas contactos, enlaces ni contenido dañino. Los organizadores revisan mensajes antes de publicarlos, rechazan contenido, atienden denuncias y bloquean usuarios. Usa Denunciar bajo un mensaje.|Rispetta gli altri. Non condividere contatti personali, link o contenuti dannosi. Gli organizzatori esaminano i messaggi prima della pubblicazione, rifiutano contenuti, gestiscono segnalazioni e bloccano partecipanti. Usa Segnala sotto un messaggio.
Delete profile removes your device data and your original iCloud messages; shared devices refresh deleted content on their next sync. Deletion requires a connection if iCloud was enabled. You may also remove Bora Jogar's Apple sign-in in device Settings.|Excluir perfil remove dados do dispositivo e suas mensagens originais no iCloud. Outros dispositivos atualizam o conteúdo na próxima sincronização. A exclusão precisa de conexão se o iCloud foi ativado. Você também pode remover o acesso Apple nos Ajustes.|Profil löschen entfernt Gerätedaten und deine ursprünglichen iCloud-Nachrichten. Geteilte Geräte aktualisieren gelöschte Inhalte bei der nächsten Synchronisierung. Nach iCloud-Aktivierung ist eine Verbindung erforderlich. Du kannst die Apple-Anmeldung in den Einstellungen entfernen.|Supprimer le profil efface les données locales et vos messages iCloud d'origine. Les autres appareils actualisent les suppressions à la prochaine synchronisation. Une connexion est requise si iCloud était activé. Vous pouvez retirer l'accès Apple dans Réglages.|Eliminar perfil borra datos locales y tus mensajes originales de iCloud. Otros dispositivos actualizan el contenido en la próxima sincronización. Se requiere conexión si activaste iCloud. También puedes retirar el acceso Apple en Ajustes.|Elimina profilo rimuove dati locali e messaggi iCloud originali. Gli altri dispositivi aggiornano le eliminazioni alla sincronizzazione successiva. Se iCloud era attivo serve una connessione. Puoi rimuovere l'accesso Apple in Impostazioni.
Support: use the team invitation's organizer contact, or export your data for the app publisher. A publisher privacy URL and support contact must be set before distribution.|Suporte: contate o organizador pelo convite da equipe ou exporte seus dados para o editor do app. A URL de privacidade e o contato do editor devem ser definidos antes da distribuição.|Support: Nutze den Organisatorkontakt aus der Einladung oder exportiere Daten für den Herausgeber. Datenschutz-URL und Supportkontakt des Herausgebers müssen vor Vertrieb festgelegt werden.|Assistance : contactez l'organisateur par l'invitation ou exportez les données pour l'éditeur. L'URL de confidentialité et le contact de l'éditeur doivent être définis avant distribution.|Soporte: usa el contacto del organizador de la invitación o exporta datos para el editor. Deben configurarse la URL de privacidad y el contacto del editor antes de distribuir.|Assistenza: contatta l'organizzatore tramite l'invito o esporta i dati per l'editore. URL privacy e contatto dell'editore devono essere impostati prima della distribuzione.'''
extra=r'''This invitation has no team data.|Este convite não contém dados da equipe.|Diese Einladung enthält keine Teamdaten.|Cette invitation ne contient aucune donnée d'équipe.|La invitación no contiene datos del equipo.|L'invito non contiene dati della squadra.
Sign in to iCloud in Settings to collaborate. Your local data is safe.|Entre no iCloud nos Ajustes para colaborar. Seus dados locais estão seguros.|Melde dich in den Einstellungen bei iCloud an. Deine lokalen Daten bleiben sicher.|Connectez-vous à iCloud dans Réglages. Vos données locales sont conservées.|Inicia sesión en iCloud en Ajustes. Tus datos locales están a salvo.|Accedi a iCloud in Impostazioni. I dati locali sono al sicuro.
The iCloud account changed. Export local data before deleting your profile and signing in again.|A conta do iCloud mudou. Exporte os dados antes de excluir o perfil e entrar novamente.|Das iCloud-Konto wurde geändert. Exportiere lokale Daten, bevor du das Profil löschst und dich erneut anmeldest.|Le compte iCloud a changé. Exportez les données avant de supprimer le profil et de vous reconnecter.|La cuenta de iCloud cambió. Exporta los datos antes de eliminar el perfil y volver a entrar.|L'account iCloud è cambiato. Esporta i dati prima di eliminare il profilo e accedere di nuovo.
This team changed on another device. Choose which version to keep.|A equipe mudou em outro dispositivo. Escolha a versão que deseja manter.|Dieses Team wurde auf einem anderen Gerät geändert. Wähle die Version, die bleiben soll.|L'équipe a changé sur un autre appareil. Choisissez la version à conserver.|El equipo cambió en otro dispositivo. Elige qué versión conservar.|La squadra è cambiata su un altro dispositivo. Scegli la versione da conservare.
Team storage is full. Export data and start a new team.|O armazenamento da equipe está cheio. Exporte os dados e crie outra equipe.|Der Teamspeicher ist voll. Exportiere Daten und erstelle ein neues Team.|Le stockage d'équipe est plein. Exportez les données et créez une équipe.|El almacenamiento está lleno. Exporta los datos y crea otro equipo.|L'archivio squadra è pieno. Esporta i dati e crea un'altra squadra.
Organizer key is missing on this device. Restore keys before syncing.|A chave do organizador está ausente. Restaure as chaves antes de sincronizar.|Der Organisatorschlüssel fehlt. Stelle Schlüssel vor der Synchronisierung wieder her.|La clé de l'organisateur manque. Restaurez les clés avant de synchroniser.|Falta la clave del organizador. Restaura las claves antes de sincronizar.|Manca la chiave dell'organizzatore. Ripristina le chiavi prima di sincronizzare.
Invalid team key.|Chave da equipe inválida.|Ungültiger Teamschlüssel.|Clé d'équipe invalide.|Clave de equipo inválida.|Chiave squadra non valida.
Organizer key unavailable.|Chave do organizador indisponível.|Organisatorschlüssel nicht verfügbar.|Clé de l'organisateur indisponible.|Clave del organizador no disponible.|Chiave dell'organizzatore non disponibile.
Could not protect the organizer key.|Não foi possível proteger a chave do organizador.|Organisatorschlüssel konnte nicht geschützt werden.|Impossible de protéger la clé de l'organisateur.|No se pudo proteger la clave del organizador.|Impossibile proteggere la chiave dell'organizzatore.
Save your attendance locally. It syncs when you open Bora Jogar.|Salve sua presença localmente. Ela sincroniza ao abrir Bora Jogar.|Speichere deine Teilnahme lokal. Sie wird beim Öffnen von Bora Jogar synchronisiert.|Enregistrez votre présence localement. Elle se synchronise à l'ouverture de Bora Jogar.|Guarda tu asistencia localmente. Se sincroniza al abrir Bora Jogar.|Salva la presenza localmente. Si sincronizza all'apertura di Bora Jogar.
Match|Jogo|Spiel|Match|Partido|Partita'''
translations={}
for line in (rows+'\n'+long+'\n'+privacy+'\n'+extra).splitlines():
 v=line.split('|')
 if len(v)!=6:raise Exception(line)
 translations[v[0].replace('\\n','\n')]=[x.replace('\\n','\n') for x in v[1:]]
file=R/'Localizable.xcstrings';d=json.loads(file.read_text());src=''.join(p.read_text() for p in (R.parent/'Sources').glob('*.swift'))
for k in re.findall(r'vErr\("([^"\n]+)"\)',src):d['strings'].setdefault(k,{'localizations':{}})
for k,t in translations.items():
 d['strings'].setdefault(k,{'localizations':{}})
 for locale,value in zip(['pt-BR','de','fr','es','it'],t):d['strings'][k]['localizations'][locale]={'stringUnit':{'state':'translated','value':value}}
for k,v in d['strings'].items():v['localizations']['en']={'stringUnit':{'state':'translated','value':k}}
file.write_text(json.dumps(d,ensure_ascii=False,indent=2))
missing=[k for k in d['strings'] if k not in translations and k not in ['Bora Jogar','OK']]
(R.parent.parent/'QA/translation-gaps.json').write_text(json.dumps(missing,ensure_ascii=False,indent=2));print('Untranslated:',missing)
