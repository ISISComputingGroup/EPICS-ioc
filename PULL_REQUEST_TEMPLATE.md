### Description of work

*Add your own description here*

### To test

*Which ticket does this PR fix?*

### Acceptance criteria

*List the acceptance criteria for the PR*

---

#### Code Review

- [ ] **Pertitent information and a copy of the manual has been stored in the [wiki](https://github.com/ISISComputingGroup/ibex_developers_manual/wiki/Specific-Device-IOC)**
- [ ] Does the IOC conform to IBEX standards?
    - [PV naming](https://github.com/ISISComputingGroup/ibex_developers_manual/wiki/PV-Naming).
    - [Disable records](https://github.com/ISISComputingGroup/ibex_developers_manual/wiki/Disable-records)
    - [Record simulation](https://github.com/ISISComputingGroup/ibex_developers_manual/wiki/Record-Simulation)
    - [Finishing touches](https://github.com/ISISComputingGroup/ibex_developers_manual/wiki/IOC-Finishing-Touches)
- [ ] If an OPI has been modified, does it conform to the [style guidelines](https://github.com/ISISComputingGroup/ibex_developers_manual/wiki/OPI-Creation)?
- [ ] Do the IOC and support module conform to the new [build guidelines](https://github.com/ISISComputingGroup/ibex_developers_manual/wiki/Reducing-Build-Dependencies)
- [ ] Have the changes been recorded appropriately in the [release notes](https://github.com/ISISComputingGroup/IBEX/wiki/ReleaseNotes_Dev)?

### Functional Tests

- IOC responds correctly in:
    - [ ] Devsim mode
    - [ ] Recsim mode
    - [ ] Real device, if available
- [ ] Supplementary IOCs (`..._0n` where `n>1`) run correctly
- [ ] Log files do not report undefined macros (serach for `macLib: macro` to find instances of `macLib: macro [macro name] is undefined...`

### Final steps

- [ ] Update the IOC submodule in the main EPICS repo. See [Git workflow](https://github.com/ISISComputingGroup/ibex_developers_manual/wiki/Git-workflow) page for details.
- [ ] Reviewer has moved the [release notes](https://github.com/ISISComputingGroup/IBEX/wiki/ReleaseNotes_Dev) entry for this ticket in the "Changes merged into master" section
