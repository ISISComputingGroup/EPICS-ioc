### Description of work

*Add your own description here*

### To test

*Which ticket does this PR fix?*

### Acceptance criteria

*List the acceptance criteria for the PR*

---

#### Code Review

- [ ] A copy of the manual has been placed on the shared drive
- [ ] Pertitent information has been stored in the [wiki](https://github.com/ISISComputingGroup/ibex_developers_manual/wiki/Specific-Device-IOC)
- [ ] Does the IOC conform to IBEX standards?
    - [PV naming](https://github.com/ISISComputingGroup/ibex_developers_manual/wiki/PV-Naming).
    - [Disable records](https://github.com/ISISComputingGroup/ibex_developers_manual/wiki/Disable-records)
    - [Record simulation](https://github.com/ISISComputingGroup/ibex_developers_manual/wiki/Record-Simulation)
    - [Finishing touches](https://github.com/ISISComputingGroup/ibex_developers_manual/wiki/IOC-Finishing-Touches)
- [ ] If an OPI has been modified, does it conform to the [style guidelines](https://github.com/ISISComputingGroup/ibex_developers_manual/wiki/OPI-Creation)?
- [ ] Do the IOC and support module conform to the new [build guidelines](https://github.com/ISISComputingGroup/ibex_developers_manual/wiki/Reducing-Build-Dependencies)
- [ ] Have the changes been recorded appropriately in a PR for [release notes](https://github.com/ISISComputingGroup/IBEX/blob/master/release_notes/ReleaseNotes_Upcoming.md)?
- [ ] Is the device's flow control setting correct? [For most devices flow control should be OFF](https://github.com/ISISComputingGroup/ibex_developers_manual/wiki/Flow-control).

### Functional Tests

- IOC responds correctly in:
    - [ ] Devsim mode
    - [ ] Recsim mode
    - [ ] Real device, if available
- [ ] Supplementary IOCs (`..._0n` where `n>1`) run correctly
- [ ] Log files do not report undefined macros (serach for `macLib: macro` to find instances of `macLib: macro [macro name] is undefined...`

### Final steps

- [ ] Update the IOC submodule in the main EPICS repo. See [Git workflow](https://github.com/ISISComputingGroup/ibex_developers_manual/wiki/Git-workflow) page for details.
- [ ] Reviewer has merged the associated PR for the [release notes](https://github.com/ISISComputingGroup/IBEX/blob/master/release_notes/ReleaseNotes_Upcoming.md)
