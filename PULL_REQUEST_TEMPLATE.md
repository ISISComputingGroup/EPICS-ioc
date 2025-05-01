### Description of work

*Add your own description here*

### To test

*Which ticket does this PR fix?*

### Acceptance criteria

*List the acceptance criteria for the PR*

---

#### Code Review

- [ ] A copy of the manual has been placed on the shared drive
- [ ] Pertitent information has been stored in the [wiki](https://isiscomputinggroup.github.io/ibex_developers_manual/Specific-IOCs.html)
- [ ] Does the IOC conform to IBEX standards?
    - [PV naming](https://isiscomputinggroup.github.io/ibex_developers_manual/iocs/conventions/PV-Naming.html).
    - [Disable records](https://isiscomputinggroup.github.io/ibex_developers_manual/iocs/testing/Disable-records.html)
    - [Record simulation](https://isiscomputinggroup.github.io/ibex_developers_manual/iocs/testing/Record-Simulation.html)
    - [Finishing touches](https://isiscomputinggroup.github.io/ibex_developers_manual/iocs/creation/IOC-Finishing-Touches.html)
- [ ] If an OPI has been modified, does it conform to the [style guidelines](https://isiscomputinggroup.github.io/ibex_developers_manual/client/opis/OPI-Creation.html)?
- [ ] Do the IOC and support module conform to the new [build guidelines](https://isiscomputinggroup.github.io/ibex_developers_manual/iocs/compiling/Reducing-Build-Dependencies.html)
- [ ] Have the changes been recorded appropriately in a PR for [release notes](https://github.com/ISISComputingGroup/IBEX/blob/master/release_notes/ReleaseNotes_Upcoming.md)?
- [ ] Is the device's flow control setting correct? [For most devices flow control should be OFF](https://isiscomputinggroup.github.io/ibex_developers_manual/iocs/tips_tricks/Flow-control.html).

### Functional Tests

- IOC responds correctly in:
    - [ ] Devsim mode
    - [ ] Recsim mode
    - [ ] Real device, if available
- [ ] Supplementary IOCs (`..._0n` where `n>1`) run correctly
- [ ] Log files do not report undefined macros (serach for `macLib: macro` to find instances of `macLib: macro [macro name] is undefined...`

### Final steps

- [ ] Update the IOC submodule in the main EPICS repo. See [Git workflow](https://isiscomputinggroup.github.io/ibex_developers_manual/processes/git_and_github/Git-workflow.html) page for details.
- [ ] Reviewer has merged the associated PR for the [release notes](https://github.com/ISISComputingGroup/IBEX/blob/master/release_notes/ReleaseNotes_Upcoming.md)
