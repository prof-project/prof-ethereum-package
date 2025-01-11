# The min/max CPU/memory that spamoor can use
MIN_CPU = 100
MAX_CPU = 2000
MIN_MEMORY = 128
MAX_MEMORY = 1024


def prefixed_address(address):
    return "0x" + address


def launch_prof_spamoor(
    plan,
    image,
    el_uri,
    contract_owner,
    global_node_selectors,
    sequencer_uri,
):
    plan.print("Launching prof-spamoor with URIs: {0} {1}".format(el_uri, sequencer_uri))

    plan.add_service(
        name="prof-spamoor",
        config=ServiceConfig(
            image=image,
            entrypoint=["/bin/sh", "-c", "touch main.log && tail -F main.log"],
            env_vars={
                "SEQUENCER_BEARER_TOKEN": "garbage",
            },
            min_cpu=MIN_CPU,
            max_cpu=MAX_CPU,
            min_memory=MIN_MEMORY,
            max_memory=MAX_MEMORY,
            node_selectors=global_node_selectors,
        ),
    )

    plan.exec(
        service_name="prof-spamoor",
        recipe=ExecRecipe(
            command=["/bin/sh", "-c", "nohup ./spamoor eoatx -p {0} -h {1} --rpc-sequencer {2}/sequencer -t 1 --random-target=true >main.log 2>&1 &".format(contract_owner, el_uri, sequencer_uri)]
        ),
    )
