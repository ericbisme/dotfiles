# Long waits are for moving and reading, not for watching

Eric's standing instruction: when a step is going to run for several minutes with
nothing for him to do, he wants a movement break and something worth reading. He
does not want to sit and watch intermediate output scroll by, and he needs to be
told so, because the default is to stare.

## When this fires

Before starting any step you expect to take roughly **three minutes or more**
unattended. Typical triggers in this estate:

- `npm run test:all` in mojo-lambda-admin; any full Jest run
- `make build`, `make zip`, `make release`; Docker image builds
- `terraform plan` and `terraform apply`; alias promotions and their deploy waits
- Workflow runs, fleet-runner or fleet-judgment-sweep batches, multi-agent fan-outs
- Long CloudWatch or X-Ray sweeps, S3 or ECR uploads, release pipelines
- Waiting on a cold-start gate, a soak, or a CI run

Judge by expected wall-clock, not by tool. A ten-second lint is not a wait. A
`qa-reviewer` round on a large diff is.

## What to do

1. **Start the long step in the background** so the session is free.
2. **Spawn `personal-trainer`** with the expected wait as the duration, and
   **`librarian`** if it has not run yet this session. Launch them in one message
   so they run concurrently. The trainer runs on every qualifying wait. The
   librarian runs once per session; on later waits, point him back to whatever is
   still unread from that digest rather than spawning it again.
3. **Relay both verbatim** as soon as they return. Lead the message with one plain
   line that tells him to get up: the step is running, nothing here needs him until
   the completion notification, and watching it will not make it faster.
4. **Then keep working.** When the long step finishes, pick up from the notification
   as usual and report the result.

Do not ask whether he wants the break. This is a standing rule, and asking is one
more prompt to stare at. Skip it only when he says he is stepping away already, or
when the same wait has already had its break in this session.

## What this is not

It is not a reason to slow the work down, and it is not a substitute for reporting.
The break message and the completion report are separate messages. If a long step
fails, the failure report comes first and in full; the trainer and librarian output
is never merged into it.
