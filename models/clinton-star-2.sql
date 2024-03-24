SELECT date, location, city, state, lat, lng,
CASE
      WHEN state IN ('FL', 'PA', 'OH', 'MI', 'WI', 'NC', 'AZ', 'NH', 'NV', 'IA', 'CO', 'VA', 'MN') THEN 'Swing'
      WHEN state IN ('CA', 'NY', 'IL', 'MA', 'VT', 'MD', 'NJ', 'WA', 'OR', 'CT', 'DE', 'HI', 'ME', 'RI', 'NM') THEN 'Blue'
      WHEN state IN ('TX', 'AL', 'KY', 'ID', 'MT', 'WY', 'ND', 'SD', 'NE', 'KS', 'OK', 'MO', 'AR', 'LA', 'MS', 'TN', 'GA', 'SC', 'WV', 'AK', 'UT', 'IN') THEN 'Red'
    END AS category
FROM `tmc.clinton`