ADMIN_KEY_INDEX = 0
USER_KEY_INDEX = 2

# The min/max CPU/memory that mev-flood can use
MIN_CPU = 100
MAX_CPU = 2000
MIN_MEMORY = 128
MAX_MEMORY = 1024


def prefixed_address(address):
    return "0x" + address


def launch_mev_flood(
    plan,
    image,
    el_uri,
    contract_owner,
    normal_user,
    global_node_selectors,
    sequencer_uri=None,
    instance_name="mev-flood",
):
    # Print the URI we're trying to use
    plan.print("Launching mev-flood with URI: {0}".format(el_uri))

    # Add service with unique name
    plan.add_service(
        name=instance_name,
        config=ServiceConfig(
            image=image,
            entrypoint=["/bin/sh", "-c", "touch main.log && tail -F main.log"],
            min_cpu=MIN_CPU,
            max_cpu=MAX_CPU,
            min_memory=MIN_MEMORY,
            max_memory=MAX_MEMORY,
            node_selectors=global_node_selectors,
        ),
    )

    # ToDo: check
    # Initialize without the -s flag
    init_command = "./run init -r {0} -k {1} -u {2} -s deployment.json".format(
        el_uri,
        prefixed_address(contract_owner),
        prefixed_address(normal_user),
    )
    plan.exec(
        service_name=instance_name,
        recipe=ExecRecipe(
            command=["/bin/sh", "-c", init_command]
        ),
    )


def spam_in_background(
    plan, 
    el_uri, 
    mev_flood_extra_args, 
    seconds_per_bundle, 
    contract_owner, 
    normal_user,
    send_to="mempool",
    sequencer_uri=None,    # Move optional parameter to the end
    instance_name="mev-flood",  # Add instance_name parameter with default value
):
    owner, user = prefixed_address(contract_owner), prefixed_address(normal_user)
    command = [
        "/bin/sh",
        "-c",
        # "nohup ./run spam -r {0} -k {1} -u {2} -p {3} -s {4} -f {5} -t 10 -l deployment.json >main.log 2>&1 &".format(
        "nohup ./run spam -r {0} -k {1} -u {2} -p {3} -s {4} -f {5} -l deployment.json >main.log 2>&1 &".format(
            el_uri, owner, user, seconds_per_bundle, send_to, sequencer_uri
        ),
    ]
    if mev_flood_extra_args:
        joined_extra_args = " ".join(mev_flood_extra_args)
        command = [
            "/bin/sh",
            "-c",
            "nohup ./run spam -r {0} -k {1} -u {2} -s {3} -l deployment.json  --secondsPerBundle {3} {4} >main.log 2>&1 &".format(
                el_uri, owner, user, seconds_per_bundle, sequencer_uri, joined_extra_args
            ),
        ]
    plan.exec(service_name=instance_name, recipe=ExecRecipe(command=command))
