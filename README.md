Chemotherapy Codes
==================

The data files contained in this directory contain three lists of medical codes standard in the U.S. that can be used to extract information on chemotherapy from clinical and/or billing data.  The lists were originally compiled by Tom Delate for the Pharmacovigilance and RxBurden studies, from a variety of sources, including:

1. Prior literature
2. SEER RX
3. The PharmD's practicing at KP Colorado
4. Consultation w/Heather Dakki and Karen Wells of Henry Ford to include their homegrown codes that were not mappable to standard procedure codes.


Variables of Note
-----------------
chemo_type:  A very high-level classification of the type of chemo indicated by the code.  Values include:

|chemo_type  | description                                                                                                                                             |
|------------|---------------------------------------------------------------------------------------------------------------------------------------------------------|
|A           | Anthracycline                                                                                                                                           |
|H           | Herceptin                                                                                                                                               |
|I           | Immunotherapy                                                                                                                                           |
|O           | An agent other than Anthracycline, Herceptin, Immunotherapy or Hormone therapy                                                                          |
|R           | Hormone therapy                                                                                                                                         |
|U           | Unknown agent--used for generic procedure codes indicating e.g., infusions, but not tied to any specific agent.  Should not occur in the list of drugs. |

Caveats
-------
Our intention, expectation & hope is that the list is complete and accurate for chemo treatment in use between 1990 and 2009.  However, because the set of NDCs (in particular) that tie to a particular agent can multiply quickly, it should not be used uncritically for applications where an absolutely complete list is important.  It should be useful as a start for updated lists, however.

If You Use The List
-------------------
Please add a comment to this page if you use this list & let us (and other prospective users) know about your experience.

Please send any missing or new codes you discover to Roy Pardee, so we can include them in this file, so that future users can benefit from your work (just as you're benefiting from Tom's).