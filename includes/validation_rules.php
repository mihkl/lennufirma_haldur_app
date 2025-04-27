<?php

// Central place to define validation rules for different forms/actions
// Format: 'action_name' => ['field_name' => 'rule1|rule2:param|...']

function getValidationRules(string $action, array $context = []): array
{
    $common_rules = [
        // Define any common rules if needed
    ];

    $rules = [
        'do_register_flight' => [
            'kood' => 'required|max:10|alpha_num',
            'lahtelennujaam_kood' => 'required|max:3', // Could add 'in:TLL,HEL,ARN...' if airports are static
            'sihtlennujaam_kood' => 'required|max:3',
            'eeldatav_lahkumisaeg' => 'required|datetime',
            'eeldatav_saabumisaeg' => 'required|datetime',
            'lennukitüüp_kood' => 'max:20|alpha_num',
            'lennuk_reg_nr' => 'max:10' // Basic check, more specific regex possible
        ],
        'do_cancel_flight' => [
            'lennu_kood' => 'required|max:10',
            'pohjus' => 'required|min:5'
        ],
        'do_delay_flight' => [
            'lennu_kood' => 'required|max:10',
            'uus_lahkumisaeg' => 'required|datetime',
            'uus_saabumisaeg' => 'required|datetime'
        ],
        'do_delete_flight' => [
            'lennu_kood' => 'required|max:10'
        ],
         'do_modify_flight' => [ // Added for OP14
            'kood' => 'required|max:10',
            'uus_lahkumisaeg' => 'required|datetime',
            'uus_saabumisaeg' => 'required|datetime',
            'uus_lennukitüüp_kood' => 'max:20|alpha_num',
            'uus_lennuk_reg_nr' => 'max:10',
            'uus_sihtkoht_kood' => 'required|max:3',
            'uus_lahtekoht_kood' => 'required|max:3',
        ],
        'do_assign_aircraft' => [
            'lennu_kood' => 'required|max:10',
            'lennuk_reg_nr' => 'required|max:10'
        ],
        'do_add_employee' => [
            'lennu_kood' => 'required|max:10',
            'tootaja_isik_id' => 'required|integer|positive',
            'rolli_kood' => 'required|max:20'
        ],
        'do_remove_employee' => [
            'lennu_kood' => 'required|max:10',
            'tootaja_isik_id' => 'required|integer|positive'
        ],

        // --- CRUD Validation Rules ---
        'do_create_airport' => [
            'kood' => 'required|max:3|alpha_num', // Often uppercase alpha
            'nimi' => 'required|max:100',
            'koordinaadid_laius' => 'numeric', // Allow empty or numeric
            'koordinaadid_pikkus' => 'numeric',
            'ajavöönd_kood' => 'required|max:50',
            'seisund_kood' => 'required|max:20'
        ],
         'do_update_airport' => [
             'kood' => 'required|max:3', // Key is usually not changed, but needed for WHERE
             'nimi' => 'required|max:100',
             'koordinaadid_laius' => 'numeric',
             'koordinaadid_pikkus' => 'numeric',
             'ajavöönd_kood' => 'required|max:50',
             'seisund_kood' => 'required|max:20'
         ],
         'do_delete_airport' => [
            'kood' => 'required|max:3'
         ],

         'do_create_aircraft_type' => [
             'kood' => 'required|max:20|alpha_num',
             'nimetus' => 'required|max:100',
             'lennuki_tootja_kood' => 'required|max:20',
             'maksimaalne_lennukaugus' => 'required|integer|positive',
             'maksimaalne_reisijate_arv' => 'required|integer|min:0',
             'pardapersonali_arv' => 'required|integer|min:0',
             'pilootide_arv' => 'required|integer|positive'
         ],
         'do_update_aircraft_type' => [
              'kood' => 'required|max:20', // Key
              'nimetus' => 'required|max:100',
              'lennuki_tootja_kood' => 'required|max:20',
              'maksimaalne_lennukaugus' => 'required|integer|positive',
              'maksimaalne_reisijate_arv' => 'required|integer|min:0',
              'pardapersonali_arv' => 'required|integer|min:0',
              'pilootide_arv' => 'required|integer|positive'
         ],
          'do_delete_aircraft_type' => [
            'kood' => 'required|max:20'
         ],

         'do_create_aircraft' => [
             'registreerimisnumber' => 'required|max:10',
             'lennukitüüp_kood' => 'required|max:20',
             'seisund_kood' => 'required|max:20'
         ],
         'do_update_aircraft' => [
             'registreerimisnumber' => 'required|max:10', // Key
             'lennukitüüp_kood' => 'required|max:20',
             'seisund_kood' => 'required|max:20'
         ],
         'do_delete_aircraft' => [
            'registreerimisnumber' => 'required|max:10'
         ],

         // Simplified Employee Create - combines Isik and Töötaja
          'do_create_employee' => [
              'eesnimi' => 'required|max:50|alpha_space',
              'perenimi' => 'required|max:50|alpha_space',
              'e_meil' => 'required|email|max:254',
              // Add other isik fields if needed (birth date, etc.)
              'töötaja_kood' => 'max:20|alpha_num', // Employee code is optional in DB schema
              'seisund_kood' => 'required|max:20' // Employee status
          ],
          // Update only employee status/code for simplicity
          'do_update_employee' => [
              'isik_id' => 'required|integer|positive', // Key
              'töötaja_kood' => 'max:20|alpha_num',
              'seisund_kood' => 'required|max:20'
          ],
          'do_delete_employee' => [
              'isik_id' => 'required|integer|positive'
          ],

        // Add rules for other actions...
    ];

    // Add dynamic 'in' rules based on fetched dropdown data
    if (isset($rules[$action])) {
        if (isset($rules[$action]['lahtelennujaam_kood']) && !empty($context['airports'])) {
             $rules[$action]['lahtelennujaam_kood'] .= '|in:' . implode(',', array_keys($context['airports']));
        }
         if (isset($rules[$action]['sihtlennujaam_kood']) && !empty($context['airports'])) {
             $rules[$action]['sihtlennujaam_kood'] .= '|in:' . implode(',', array_keys($context['airports']));
        }
        if (isset($rules[$action]['uus_lahtekoht_kood']) && !empty($context['airports'])) {
             $rules[$action]['uus_lahtekoht_kood'] .= '|in:' . implode(',', array_keys($context['airports']));
        }
         if (isset($rules[$action]['uus_sihtkoht_kood']) && !empty($context['airports'])) {
             $rules[$action]['uus_sihtkoht_kood'] .= '|in:' . implode(',', array_keys($context['airports']));
        }
        if (isset($rules[$action]['ajavöönd_kood']) && !empty($context['timezones'])) {
             $rules[$action]['ajavöönd_kood'] .= '|in:' . implode(',', array_keys($context['timezones']));
        }
         if (isset($rules[$action]['seisund_kood']) && !empty($context['airport_statuses'])) { // Adjust context key as needed
             $rules[$action]['seisund_kood'] .= '|in:' . implode(',', array_keys($context['airport_statuses']));
        }
        // Add more dynamic 'in' rules for other dropdowns (aircraft types, statuses, manufacturers, etc.)
    }


    return $rules[$action] ?? [];
}

?>