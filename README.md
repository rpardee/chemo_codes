Chemotherapy Codes
==================

The data files contained in this repository contain three lists of medical codes (and associated descriptions) standard in the U.S. that can be used to extract information on chemotherapy events from clinical and/or billing data.  The lists were originally compiled by a panel of experts from several Cancer Research Network Investigators for the Pharmacovigilance and RxBurden studies, from a variety of sources, including:

1. Prior literature
2. SEER RX
3. The PharmD's practicing at KP Colorado

We are making this list available in the hopes that it will be useful to researchers outside of the Cancer Research Network in their work.

Data Formats
------------
The actual code lists are contained in the /data subdirectory, in 3 different formats:

* csv files--plain text files easily read into Excel and many other programs.
* sas7bdat files--binary SAS datasets for use by SAS programs.
* chemo_codes.mdb--a Microsoft Access database file containing tables holding the various lists.

_These lists are all equivalent--please feel free to use whichever format is easiest for you._

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
I would love to get a message to let me know that you used the list, what you used it for, and whether it was or was not helpful to you.  Please use github's messaging facility to do that.

If You Would Like To Contribute Additional Codes
------------------------------------------------
Do please "pay it forward" and send additional codes that should be on these lists.  You can do so either by formal pull request, or just via e-mail.

Thanks!

The Cancer Research Network
