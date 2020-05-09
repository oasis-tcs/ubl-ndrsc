# README

Members of the [Universal Business Language (UBL) TC](https://www.oasis-open.org/committees/ubl/) 
create and manage technical content in this [TC GitHub repository](https://github.com/oasis-tcs/ubl-ndrsc/) 
as part of the TC's chartered work (the program of work and deliverables described in its 
[charter](https://www.oasis-open.org/committees/ubl/charter.php).

OASIS TC GitHub repositories, as described in 
[GitHub Repositories for OASIS TC Members' Chartered Work](https://www.oasis-open.org/resources/tcadmin/github-repositories-for-oasis-tc-members-chartered-work), 
are governed by the OASIS [TC Process](https://www.oasis-open.org/policies-guidelines/tc-process), [IPR Policy](https://www.oasis-open.org/policies-guidelines/ipr), 
and other policies. While they make use of public GitHub repositories, these repositories are distinct from 
[OASIS Open Repositories](https://www.oasis-open.org/resources/open-repositories), which are used for 
development of open source [licensed](https://www.oasis-open.org/resources/open-repositories/licenses) 
content.

## Description

For the development of the naming and design rules (NDR) artefacts.

## Contributions

As stated in this repository's 
[CONTRIBUTING](https://github.com/oasis-tcs/ubl-ndrsc/blob/master/CONTRIBUTING.md) file, 
contributors to this repository must be Members of the OASIS UBL TC for any substantive contributions 
or change requests.  Anyone wishing to contribute to this GitHub project and 
[participate](https://www.oasis-open.org/join/participation-instructions) in the TC's technical 
activity is invited to join as an OASIS TC Member. Public feedback is also accepted, 
subject to the terms of the 
[OASIS Feedback License](https://www.oasis-open.org/policies-guidelines/ipr#appendixa). 

## Licensing

Please see the [LICENSE](https://github.com/oasis-tcs/ubl-ndrsc/blob/master/LICENSE.md) file 
for description of the license terms and OASIS policies applicable to the TC's work in this GitHub 
project. Content in this repository is intended to be part of the UBL TC's permanent record of activity, 
visible and freely available for all to use, subject to applicable OASIS policies, as presented in the 
repository [LICENSE](https://github.com/oasis-tcs/ubl-ndrsc/blob/master/LICENSE.md). 

## Further Description of this Repository

This repository is for the artefacts:
- OASIS Business Document Naming and Design Rules (BDNDR) v1.1
  - `Business-Document-NDR-v1.1-{stage}.xml`
  - this XML requires an entity file:
    - `Business-Document-NDR-v1.1-{stage}-summary.ent`
    - this entity file is created using the stylesheet fragments:
      - `massage-NDR.xsl`
      - `check-UBL-NDR-3.0.xsl`
- UBL Naming and Design Rules v3.1
  - `UBL-NDR-v3.1-{stage}.xml`
- UBL 2.1 JSON Serialization v2.0
  - `UBL-2.1-JSON-v2.0-{stage}.xml`
- UBL 2.2 JSON Serialization v1.0
  - `UBL-2.2-JSON-v1.0-{stage}.xml`
- UBL 2.3 JSON Serialization v1.0
  - `UBL-2.3-JSON-v1.0-{stage}.xml`

Opening the authored XML documents in an XSLT-aware browser (e.g. Safari) allows one to peruse the final document as if it had been published in HTML.

Included in the BDNDR results are the following schema fragments:
- XML Schema XSD:
  - `BDNDR-CCTS_CCT_SchemaModule-1.1.xsd`
  - `BDNDR-UnqualifiedDataTypes-1.1.xsd`
- JSON Schema:
  - `BDNDR-CCTS_CCT_SchemaModule-1.1.json`
  - `BDNDR-UnqualifiedDataTypes-1.1.json`

When the JSON Schemas and serializations have changed, the following directories must be updated with the results of recreating the JSON artefacts:
- `UBL-2.1-JSON-results` - `/val`, `/json-schema`
- `UBL-2.2-JSON-results` - `/val`, `/json-schema`
- `UBL-2.3-JSON-results` - `/val`, `/json-schema`

The `/json` subdirectory in each of the above is a transliteration of that UBL release's suite of XML sample instances individually converted to JSON using:
- `CCTSXML2JSON.xsl` (see `readme-CCTSXML2JSON.html` for the documentation)

Support subdirectories:
- [`art`]( art ) - high-res artwork for PDF publishing
- [`db`]( db ) - HTMl runtime event for DocBook from OASIS DocBook templates
- [`htmlart`]( htmlart ) - low-res artwork for HTML publishing
- [`utilities`]( utilities ) - tools used to generate outputs

For those with publishing privileges, the invocation of the packaging scripts is as follows:
- Business Document Naming and Design rules
  - `sh packageBDNDR11.sh target stage label localDateTime serverUsername serverPassword`
  - `packageBDNDR11.bat target stage label localDateTime serverUsername serverPassword`
- UBL Naming and Design rules
  - `sh packageUBLNDR.sh target stage label localDateTime serverUsername serverPassword`
  - `packageUBLNDR.bat target stage label localDateTime serverUsername serverPassword`
- JSON Serialization
  - `sh packageUBLJSON.sh target ublVersion stage label localDateTime serverUsername serverPassword`
  - `packageUBLJSON.bat target ublVersion stage label localDateTime serverUsername serverPassword`
- where:
    - pre-existing target directory (without trailing "/", e.g. ../results or ..\results)
    - ublVersion (e.g. "2.1", "2.2", "2.3")
    - stage (e.g. "csd02wd03", "csprd01", "os", etc.)
    - label (e.g. "CCYYMMDD-hhmmz" UTC time as in "20200406-0250z", or any string for testing purposes)
    - localDateTime (e.g. "now" for current time, or "CCYYMMDD-hhmm" in local time as in "20200405-2250z" for EDT -0400)
    - serverUsername (for those editors with publishing privileges)
    - serverPassword (for those editors with publishing privileges)

A handy invocation is `doall.bat`/`doall.sh` that has all of the required current invocations:
  - `sh doall.sh label localDateTime serverUsername serverPassword`
  - `doall.bat label localDateTime serverUsername serverPassword`

The build results in the target directory:
  - `Business-Document-NDR-v1.1-{stage}-{label}.zip`
  - `Business-Document-NDR-v1.1-{stage}-{label}/`
  - `UBL-NDR-v3.1-{stage}-{label}.zip`
  - `UBL-NDR-v3.1-{stage}-{label}/`
  - `UBL-2.1-JSON-v2.0-{stage}-{label}.zip`
  - `UBL-2.1-JSON-v2.0-{stage}-{label}/`
  - `UBL-2.2-JSON-v1.0-{stage}-{label}.zip`
  - `UBL-2.2-JSON-v1.0-{stage}-{label}/`
  - `UBL-2.3-JSON-v1.0-{stage}-{label}.zip`
  - `UBL-2.3-JSON-v1.0-{stage}-{label}/`

## Contact

Please send questions or comments about 
[OASIS TC GitHub repositories](https://www.oasis-open.org/resources/tcadmin/github-repositories-for-oasis-tc-members-chartered-work) 
to the [OASIS TC Administrator](mailto:tc-admin@oasis-open.org).  For questions about content in this 
repository, please contact the TC Chair or Co-Chairs as listed on the the UBL TC's 
[home page](https://www.oasis-open.org/committees/ubl/).
