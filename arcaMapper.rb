#arcaMapper - code snippet (don't forget to stage it)
  attribute :display_content_partner do
    partner = fetch('/record/header/identifier').split('.').first.split(':').last
    partners = {
      'capu' => 'Capilano University', #coming sooon
      'cc' => 'Camosun College',
      'cotr' => 'College of the Rockies',
      'dc' => 'Douglas College',
      'ecuad' => 'Emily Carr University of Art and Design',
      'jibc' => 'Justice Institute of British Columbia',
      'kpu' => 'Kwantlen Polytechic Univeristy',
      'nwcc' => 'Northwest Community College', #coming sooon
      'sc' => 'Selkirk College',
      'tru' => 'Thompson Rivers University',
      'twu' => 'Trinity Western University',
      'unbc' => 'University of Northern British Columbia',
      'ufv' => 'University of Fraser Valley'
      }
    partners[partner]
  end
