SELECT
    chat_history.id AS 'No',
    chat_history.chat_id AS 'Talk room id',
    ifnull(groups.name, contacts.name) AS 'Talk room name',
    chat_history.from_mid AS 'Sender id',
    CASE
        WHEN chat_history.from_mid IS NULL THEN NULL
        ELSE contacts.name
    END AS 'Sender name',
    DATETIME(chat_history.created_time/1000, 'unixepoch', 'localtime') AS 'DATETIME(JST)',
    CASE chat_history.attachement_type
        WHEN  0 THEN chat_history.content -- Text message
        WHEN  1 THEN '[Image]' -- Image
        WHEN  3 THEN '[attachement_type=3]' -- ?
        WHEN  6 THEN chat_history.content -- Call Log
        WHEN  7 THEN '[Stamp]' -- Stamp
        WHEN 12 THEN chat_history.content -- Information from LINE
        WHEN 13 THEN '[attachement_type=13]' -- ?
        WHEN 16 THEN '[Album]' -- Information of album
        WHEN 17 THEN '[attachement_type=17]' -- Advertise?
        WHEN 18 THEN '[attachement_type=18]' -- ?
    END AS 'Contents',
    CASE
        WHEN chat_history.from_mid IS NULL THEN 'Sent'
        ELSE 'Receive'
    END AS 'Type'
FROM
    (
        chat_history LEFT OUTER JOIN groups
            ON chat_history.chat_id = groups.id
    )
    chat_history LEFT OUTER JOIN contacts
        ON chat_history.chat_id = contacts.m_id
        OR chat_history.from_mid = contacts.m_id
ORDER BY
    'No'
;
